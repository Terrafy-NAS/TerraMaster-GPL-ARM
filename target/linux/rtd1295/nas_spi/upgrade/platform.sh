#!/bin/sh

if false; then
exec 1<&-
exec 2<&-
exec 1<>/dev/console
exec 2>&1
fi

DEFAULT_IMAGEPATH="/tmp/firmware.img"
fw_set=0x00
fw_skip=0

# FW_SIZE: KB
UBOOT_SIZE=512
LOGO_SIZE=320
AFW_SIZE=1408
DTB_SIZE=64
KERNEL_SIZE=3520
ROOTFS_SIZE=2240

platform_parse_image() {
	IMAGEPATH="$DEFAULT_IMAGEPATH"
	img_size="`stat -c%s $IMAGEPATH`"
	# From MSB to LSB:
	# uboot + logo + audio fw + dtb + kernel + rootfs

	UBOOT_BYTE=$(($UBOOT_SIZE * 1024))
	LOGO_BYTE=$(($LOGO_SIZE * 1024))
	AFW_BYTE=$(($AFW_SIZE * 1024))
	DTB_BYTE=$(($DTB_SIZE * 1024))
	KERNEL_BYTE=$(($KERNEL_SIZE * 1024))
	ROOTFS_BYTE=$(($ROOTFS_SIZE * 1024))
        # FW_BYTE=7733248
        FW_BYTE=$(($LOGO_BYTE + $AFW_BYTE + $DTB_BYTE + $KERNEL_BYTE + $ROOTFS_BYTE))
        FULL_BYTE=$(($FW_BYTE + $UBOOT_BYTE))

        case "$(($img_size - 32))" in
		"$FULL_BYTE") # uboot + all FWs
			fw_set=0x3f
			;;
		"$FW_BYTE") # all FWs
			fw_set=0x1f
			;;
		"$ROOTFS_BYTE") # initrd
			fw_set=0x01
			;;
		"$(($DTB_BYTE + $KERNEL_BYTE))") # DTB + kernel
			fw_set=0x06
			;;
		"$DTB_BYTE") # kernel DTB
			fw_set=0x04
			;;
		"$AFW_BYTE") # audio fw
			fw_set=0x08
			;;
		"$LOGO_BYTE") # logo
			fw_set=0x10
			;;
		"$UBOOT_BYTE") # uboot
			fw_set=0x20
			;;
		*)
			v "Can not find the firmware file"
			return 1
			;;
	esac

	return 0
}

platform_hash_verification() {
	# file offset size
	[ "$#" -ne 3 ] && return 1

	v "verifying checksum on $1, offset: $2, size:$3"

        local sha256_img=$(dd if="$1" bs=32 skip=$((($2 + $3) / 32 - 1)) count=1 | hexdump -e '8/1 "%02x"' 2>/dev/null)
        local sha256_chk=$(dd if="$1" bs=32 skip=$(($2 / 32)) count=$(($3 / 32 - 1))| sha256sum -b | head -c 64 2>/dev/null)

	if [ -n "$sha256_img" -a -n "$sha256_chk" ] && [ "$sha256_img" = "$sha256_chk" ]; then
		return 0
	else
		echo "Invalid image. Contents do not match checksum (image:$sha256_img calculated:$sha256_chk)"
		rm $IMAGEPATH
		return 1
	fi
}

platform_check_image() {
	v "platform_check_image"
	v "image path/url: $1"

	# Should have 7 mtd partitions: factory, uboot, logo, afw, dtb, kernel and initrd.
	local npart=`cat /proc/mtd | grep mtd | wc -l`
	if [ $npart -ne 7 ]; then
		echo "Sysupgrade is not supported on this board yet."
		return 1
	fi

	case "$1" in
		http://*|ftp://*)
			eval "wget -O$DEFAULT_IMAGEPATH -q $1"
			IMAGEPATH="$DEFAULT_IMAGEPATH"
			;;
		*)
			[ "$1" != "$DEFAULT_IMAGEPATH" ] && eval "cp $1 $DEFAULT_IMAGEPATH"
			IMAGEPATH="$DEFAULT_IMAGEPATH"
			;;
	esac

	if [ -f $IMAGEPATH ]; then
		img_size="`stat -c%s $IMAGEPATH`"
                if ! platform_hash_verification $IMAGEPATH 0 $img_size; then
			return 1
		fi
	else
		v "Can not find the firmware file"
		return 1
	fi

	if ! platform_parse_image; then
		v "Firmware configuration is not supported!"
		return 1
	fi

	return 0
}

platform_check_burn_image() {
	# bitmask bs skip count label
	[ "$#" -ne 5 ] && return 1

        hex=`printf '0x%X' "$1"`
	if [ "$1" -eq "$(($fw_set & $hex))" ]; then
		if ! platform_hash_verification $IMAGEPATH $(($2 * $3)) $(($2 * $4)); then
			return 1
		fi
		dd if="$IMAGEPATH" bs=$2 skip=$3 count=$4 | mtd write - $5
		fw_skip=$((fw_skip + $4))
	fi
	return 0
}

platform_do_upgrade() {
	# $1: image path/url
	v "platform_do_upgrade start"
	v "image path/url: $1"

	IMAGEPATH="$DEFAULT_IMAGEPATH"

	if ! platform_parse_image; then
		v "Firmware configuration is not supported!"
		return 1
	fi

	bitmask=32
	bs=4096
        for count in "$(($UBOOT_SIZE/4)) uboot" "$(($LOGO_SIZE/4)) logo"\
            "$(($AFW_SIZE/4)) afw" "$(($DTB_SIZE/4)) dtb"\
            "$(($KERNEL_SIZE/4)) kernel" "$(($ROOTFS_SIZE/4)) initrd"; do
		if ! platform_check_burn_image $bitmask $bs $fw_skip $count; then
			return 1
		fi
		bitmask=$((bitmask >> 1))
	done

	sync
	v "platform_do_upgrade end"

	reboot
}
