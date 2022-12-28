#!/bin/bash

msg(){
    echo -n "[m[1;35m "
    echo $*
    echo -n "[m"
}

FNAME="[NAS-MKROOT]"
# components
CURDIR=`pwd`/..
PACKAGE_BASE_DIR=$CURDIR/packages/omv
msg "$FNAME PACKAGE_BASE_DIR="$PACKAGE_BASE_DIR
LAYOUT=$1
NASROOT=root.$LAYOUT.tar.bz2
TMP_DIR=$CURDIR/tmp
KMOD_FILE=modules.$LAYOUT.tar.bz2
ANDROID_ROOT_FILE=android.$LAYOUT.tar.bz2
ANDROID_SRC_DIR=$PACKAGE_BASE_DIR/root
ANDROID_DEST_DIR=$TMP_DIR/rootfs/mnt/android
OSTYPE=`/usr/bin/getconf LONG_BIT | grep 64`
[ "$OSTYPE" != "" ] && OSTYPE="_$OSTYPE"

ETC_SRC_DIR=$TMP_DIR/rootfs/usr/local/etc

# SQUASH_COMP: xz/gzip/lzo, lzma is not supported
SQUASH_COMP="xz"
SQUASH_EX_OPT="-e ./rootfs/var/lib/apt/lists/ -e ./rootfs/var/cache/apt/ -e ./rootfs/var/cache/debconf -e ./rootfs/var/lib/dpkg/info"

CONFIG=$TMP_DIR/pkgfile/config.txt
ROOTFS=`grep -e "^part = rootfs " $CONFIG | awk -F' ' '{print $5}'`
ROOT_IMG_PATH=`grep -e "^part = rootfs " $CONFIG | awk -F' ' '{print $6}'`
ROOT_IMG_NAME=`basename $ROOT_IMG_PATH`
ROOT_SIZE_BYTE=`grep -e "^part = rootfs " $CONFIG | awk -F' ' '{print $7}'`
ETC_FS_TYPE=`grep -e "^part = etc " $CONFIG | awk -F' ' '{print $5}'`
ETC_IMG_PATH=`grep -e "^part = etc " $CONFIG | awk -F' ' '{print $6}'`
ETC_IMG_NAME=`basename $ETC_IMG_PATH`
ETC_SIZE_BYTE=`grep -e "^part = etc " $CONFIG | awk -F' ' '{print $7}'`

# Binaries
MKSQUASHFS_PATH=$CURDIR/bin/mksquashfs_nas$OSTYPE
MKYAFFS2IMAGE_PATH=$CURDIR/bin/mkyaffs2image$OSTYPE
MKUBIFS_PATH=$CURDIR/bin/mkfs.ubifs_nas$OSTYPE
UBINIZE_PATH=$CURDIR/bin/ubinize_nas$OSTYPE
# EXT4
MAKE_EXT4FS=$CURDIR/bin/make_ext4fs_nas$OSTYPE
SIMG2IMG=$CURDIR/bin/simg2img
E2FSCK_PATH=e2fsck
RESIZE2FS_PATH=resize2fs
MKBOOTFS_PATH=$CURDIR/bin/mkbootfs
# FAT32
#MKFAT_PATH=$CURDIR/bin/mkfs.vfat_nas$OSTYPE
# Need to install dosfstools package
MKFAT_PATH=mkfs.vfat

error(){
    echo -n "[m[1;31m "
    echo $*
    echo -n "[m"
}
good(){
    echo -n "[m[1;32m "
    echo $*
    echo -n "[m"
}

# $0          $1
# mkrootfs.sh LAYOUT
# LAYOUT: nand/emmc

case $1 in
        nand)
NAND_BLOCK_SIZE=`cat $PACKAGE_BASE_DIR/Makefile.in | grep -e "^NAND_BLOCK_SIZE" | awk -F'=| ' '{print $2}'`
NAND_PAGE_SIZE=`cat $PACKAGE_BASE_DIR/Makefile.in | grep -e "^NAND_PAGE_SIZE" | awk -F'=| ' '{print $2}'`
NAND_LEB_SIZE=`expr $NAND_BLOCK_SIZE - $NAND_PAGE_SIZE \* 2`

                [ "$#" != 1 ] \
                    && error "$FNAME Wrong argument for nand!" && exit 1
                [ "$ETC_FS_TYPE" = "" ] && [ "$ROOTFS" != "ubifs" ] \
                    && error "$FNAME Need to use ubifs root if no etc!" && exit 1
                [ "$ROOTFS" = "squashfs" ] && [ "$ETC_FS_TYPE" != "ubifs" ] \
                    && error "$FNAME Only support ubifs ETC for nand!" && exit 1
        ;;
        emmc)
                [ "$#" != 1 ] \
                    && error "$FNAME Wrong argument for emmc!" && exit 1
                [ "$ETC_FS_TYPE" != "ext4" ] \
                    && error "$FNAME Only support ext4 ETC for emmc!" && exit 1
        ;;
        spi)
                [ "$#" != 2 ] \
                    && error "$FNAME Wrong argument for NOR flash!" && exit 1
                # Named ext4 temporary
                [ "$2" = "rtk_generic_spi" ] && \
                [ "$ETC_FS_TYPE" != "ext4" ] \
                    && error "$FNAME Only support VFAT BOOT for NOR flash!" && exit 1
        ;;
        *)
                do_usage
                exit 1
esac

PATCHED_DIR=$TMP_DIR/patched
do_rootfs_patch(){
    pushd $TMP_DIR || exit 1
        mkdir -p $PATCHED_DIR
        for x in `ls $PACKAGE_BASE_DIR/patch/*.patch 2> /dev/null`; do
            echo "$FNAME Rootfs patching: [m[1;34m `basename $x`[m"
            git --work-tree=`pwd` apply -p1 --ignore-whitespace --whitespace=nowarn $x \
                && mv -f $x $PATCHED_DIR/ \
                && good "Succeeded!" || error "Failed!"
        done
    popd
}

do_rootfs_decompression(){
    msg "$FNAME Decompressing $NASROOT..."
    tar --checkpoint=6000 --numeric-owner -jxBpf $PACKAGE_BASE_DIR/$NASROOT -C $TMP_DIR/rootfs/ \
        && good "done!" || error "failed!"

    # Apply rootfs patch
    if [ -d $PACKAGE_BASE_DIR/patch ] && [ "`ls $PACKAGE_BASE_DIR/patch/ 2> /dev/null`" != "" ]; then
        do_rootfs_patch
    fi

    do_change_usr_pwd

    # Set NAS file permission
    if [ -x $PACKAGE_BASE_DIR/patch/nasroot.sh ]; then
        pushd $TMP_DIR/rootfs || exit 1
            $PACKAGE_BASE_DIR/patch/nasroot.sh
        popd
    fi

    # Backup etc for restore function
    #do_etc_backup && good "done!" || error "failed!"

    # Re-pack rootfs if patch applied
    if [ "`ls -A $PATCHED_DIR/ 2> /dev/null`" != "" ]; then
        pushd $TMP_DIR/rootfs || exit 2
            msg "$FNAME Re-packing $NASROOT..."
            tar --checkpoint=6000 --numeric-owner -jcBpf $PACKAGE_BASE_DIR/$NASROOT * \
            && good "done!" || error "failed!"
        popd
    fi

    # Kernel modules
    if [ -f $PACKAGE_BASE_DIR/$KMOD_FILE ]; then
        msg "$FNAME Decompressing kernel modules from $KMOD_FILE..."
        tar -C $TMP_DIR/rootfs/lib/modules/ --overwrite --numeric-owner -jxBpf $PACKAGE_BASE_DIR/$KMOD_FILE \
            && good "done!" || error "failed!"
    fi
    # Android rootfs
    if [ -d $ANDROID_SRC_DIR ] && [ "`ls -A $ANDROID_SRC_DIR/ 2> /dev/null`" != "" ]; then
        msg "$FNAME Copying Android root directory..."
        mkdir -p $ANDROID_DEST_DIR
        pushd $ANDROID_DEST_DIR || exit 2
            $MKBOOTFS_PATH $ANDROID_SRC_DIR | cpio -i -n
        popd
    elif [ -f $PACKAGE_BASE_DIR/$ANDROID_ROOT_FILE ]; then
        msg "$FNAME Decompressing Android root from $ANDROID_ROOT_FILE..."
        mkdir -p $ANDROID_DEST_DIR
        tar -C $ANDROID_DEST_DIR --overwrite --numeric-owner -jxBpf $PACKAGE_BASE_DIR/$ANDROID_ROOT_FILE \
            && good "done!" || error "failed!"
    fi
    # No NAS ipcam on Media NAS
    if [ "`ls -A $ANDROID_DEST_DIR/ 2> /dev/null`" != "" ]; then
        sed -i "/<service>ipcam<\/service>/d" $TMP_DIR/rootfs/var/www/videoDB-api/tver.xml
    fi
}

do_change_usr_pwd(){
    if [ -f $PACKAGE_BASE_DIR/pwd.ini ]; then
        USERS="`cat $PACKAGE_BASE_DIR/pwd.ini`"
        # USERNAME:PASSWORD
        for USER in $USERS; do
            USERNAME=`echo $USER | awk -F':' '{print $1}'`
            PASSWORD=`echo $USER | awk -F':' '{print $2}'`

            # Change Linux user password
            SALT=`openssl rand -base64 16 | tr -d '+=' | head -c 8 || echo saltsalt`
            NewPwd=`python -c "import crypt; print crypt.crypt('$PASSWORD', '\\$6\\$\${SALT}\\$')"`
            sed -i "s%^$USERNAME:[^:]*%$USERNAME:$NewPwd%g" $ETC_SRC_DIR/etc/shadow && \
                sed -i "s%^$USERNAME:[^:]*%$USERNAME:$NewPwd%g" $TMP_DIR/rootfs/etc/shadow

            # Change web UI password
            REALM="Network Attached Storage"
            DIGEST=`echo -n "$USERNAME:$REALM:$PASSWORD" | md5sum | head -c 32`
            sed -i -r "s/$USERNAME:$REALM:([0-9|a-f]){32}/$USERNAME:$REALM:$DIGEST/g" $ETC_SRC_DIR/etc/nas/htdigest && \
                sed -i -r "s/$USERNAME:$REALM:([0-9|a-f]){32}/$USERNAME:$REALM:$DIGEST/g" $TMP_DIR/rootfs/etc/nas/htdigest
            msg "$FNAME Password changed for $USERNAME!"

            # Todo: Change SAMBA password
        done

        # Move pwd.ini to pached folder to trigger rootfs re-pack
        mkdir -p $PATCHED_DIR
        mv -f $PACKAGE_BASE_DIR/pwd.ini $PATCHED_DIR
    fi
}

do_etc_backup(){
    msg "$FNAME Backing up ETC for restore..."
    mv $TMP_DIR/rootfs/etc $TMP_DIR/etc_backup \
        && cp -a $ETC_SRC_DIR/etc $TMP_DIR/rootfs/ \
        || error "Failed to backup etc!"
    # For restore function
    FLIST="fstab openmediavault/config.xml nas mdadm/mdadm.conf passwd shadow \
        exports minidlna.conf forked-daapd.conf samba/smb.conf proftpd/proftpd.conf \
        transmission-daemon/settings.json netatalk/afp.conf \
        monit/monitrc \
        network/interfaces hosts hostname ntp.conf localtime"
    mkdir -p $TMP_DIR/rootfs/usr/local/backup/
    pushd $ETC_SRC_DIR/etc || exit 1
        tar --ignore-failed-read --overwrite --numeric-owner -jcBpf ../../backup/etc.tbz * \
            || error "Failed to create etc restore tar file!"
    popd
    # Backup SAMBA password database
    pushd $ETC_SRC_DIR || exit 1
        tar --overwrite --numeric-owner -jcBpf ../backup/var.tbz var/ \
            || error "Failed to create var restore tar file!"
    popd
    # Backup Wi-Fi related settings
    pushd $ETC_SRC_DIR || exit 1
        tar --overwrite --numeric-owner -jcBpf ../backup/wifi.tbz wifi/ \
            || error "Failed to create Wi-Fi restore tar file!"
    popd
}

case $1 in
        nand)
                # de-compress rootfs, kernel modules and android rootfs
                do_rootfs_decompression

                pushd $TMP_DIR || exit 2
                ETC_OPTS="-j `expr $NAND_LEB_SIZE \* 3` -f 4 -l 2"
                # Reduce # of log blk and jrn size on MLC NAND
                if [ $NAND_BLOCK_SIZE -lt 524288 ]; then
                    ETC_OPTS=""
                fi
                # Create Squashfs rootfs
                if [ "$ROOTFS" = "squashfs" ]; then
                    # Create ETC partition
                    $MKUBIFS_PATH -v -m $NAND_PAGE_SIZE -e $NAND_LEB_SIZE $ETC_OPTS \
                        -c `expr ${ETC_SIZE_BYTE} / ${NAND_BLOCK_SIZE} - 8` \
                        -r $ETC_SRC_DIR etc.ubifs.img || exit 3
                    $UBINIZE_PATH -v -o $ETC_IMG_NAME -m $NAND_PAGE_SIZE -p $NAND_BLOCK_SIZE $PACKAGE_BASE_DIR/etc.ini || exit 3

                    $MKSQUASHFS_PATH $TMP_DIR/rootfs/ rootfs.ubifs.img -comp $SQUASH_COMP $SQUASH_EX_OPT || exit 3
                    $UBINIZE_PATH -v -o $ROOT_IMG_NAME -m $NAND_PAGE_SIZE -p $NAND_BLOCK_SIZE $PACKAGE_BASE_DIR/rootfs.ini || exit 3
                    if [ "$ROOT_SIZE_BYTE" = "0" ]; then
                        ROOT_SIZE_BYTE=`ls -lG $ROOT_IMG_NAME | awk -F' ' '{print $4}'`
                        sed -i "s|^\(part = rootfs .*$ROOT_IMG_NAME\) \([0-9]*\)|\1 `expr ${NAND_BLOCK_SIZE} \* 41 + $ROOT_SIZE_BYTE`|g" $CONFIG
                    fi
                elif [ "$ROOTFS" = "ubifs" ]; then
                    $MKUBIFS_PATH -v -m $NAND_PAGE_SIZE -e $NAND_LEB_SIZE \
                        -c `expr ${ROOT_SIZE_BYTE} / ${NAND_BLOCK_SIZE} - 8` \
                        -r $TMP_DIR/rootfs/ rootfs.ubifs.img || exit 3
                    $UBINIZE_PATH -v -o $ROOT_IMG_NAME -m $NAND_PAGE_SIZE -p $NAND_BLOCK_SIZE $PACKAGE_BASE_DIR/rootfs.ini || exit 3
                else
                    error "$FNAME Only support squashfs or ubifs root partition for NAND!" && exit 1
                fi
                popd
        ;;
        emmc|spi)
            # emmc or rtk_generic_spi_8mb
            if [ "$2" != "rtk_generic_spi" ]; then
                # de-compress rootfs, kernel modules and android rootfs
                do_rootfs_decompression

                # Create ETC partition
                msg "$FNAME Creating ETC ext4 bin file..."
                # Reserve 8KB for extended partition table
                $MAKE_EXT4FS -l \
                    `expr ${ETC_SIZE_BYTE} / 1024 / 1024`M -b 1024 -i 8192 \
                    -L nasetc -p -s $TMP_DIR/e.bin $ETC_SRC_DIR && sync && \
                    $SIMG2IMG $TMP_DIR/e.bin $TMP_DIR/$ETC_IMG_NAME && sync && \
                    $E2FSCK_PATH -f -p $TMP_DIR/$ETC_IMG_NAME && sync && \
                    $RESIZE2FS_PATH $TMP_DIR/$ETC_IMG_NAME \
                    `expr \`expr ${ETC_SIZE_BYTE} / 1024\` - 8`K && \
                    good "done!" || error "failed!"

                # Create rootfs
                if [ "$ROOTFS" = "ext4" ]; then
                    msg "$FNAME Removing device nodes in NASROOT..."
                    dir_list="dev var/spool/postfix/dev var/spool-saved/postfix/dev"
                    for dir in $dir_list; do
                        [ -d $TMP_DIR/rootfs/$dir ] && rm -r $TMP_DIR/rootfs/$dir/*
                    done
                    msg "$FNAME Creating NASROOT ext4 bin file..."
                    $MAKE_EXT4FS -l `expr ${ROOT_SIZE_BYTE} / 1024 / 1024`M \
                        -L nasroot -p -s $TMP_DIR/r.bin $TMP_DIR/rootfs && sync && \
                        $SIMG2IMG $TMP_DIR/r.bin $TMP_DIR/$ROOT_IMG_NAME && sync && \
                        $E2FSCK_PATH -f -p $TMP_DIR/$ROOT_IMG_NAME && sync && \
                        $RESIZE2FS_PATH -M $TMP_DIR/$ROOT_IMG_NAME && \
                        good "done!" || error "failed!"
                elif [ "$ROOTFS" = "squashfs" ]; then
                    pushd $TMP_DIR || exit 2
                    $MKSQUASHFS_PATH ./rootfs/ $ROOT_IMG_NAME -comp $SQUASH_COMP $SQUASH_EX_OPT || exit 3
                    popd
                else
                    error "$FNAME Only support ext4 or squashfs root for $1!" && exit 1
                fi
            else # rtk_generic_spi
                # Create BOOT partition
                msg "$FNAME Creating BOOT FAT32 bin file..."
                dd if=/dev/zero of=$TMP_DIR/$ETC_IMG_NAME count=`expr ${ETC_SIZE_BYTE} / 1024 / 1024` bs=1M && sync && \
                    $MKFAT_PATH -n BOOT $TMP_DIR/$ETC_IMG_NAME && sync && \
                    mcopy -i $TMP_DIR/$ETC_IMG_NAME \
                        $PACKAGE_BASE_DIR/spi.uImage $PACKAGE_BASE_DIR/rescue.root.spi.cpio.gz_pad.img \
                        $PACKAGE_BASE_DIR/android.spi.dtb $PACKAGE_BASE_DIR/rescue.spi.dtb $TMP_DIR/bluecore.audio ::/ && \
                        sync && \
                    good "done!" || error "failed!"

                # de-compress rootfs, kernel modules and android rootfs
                do_rootfs_decompression

                # Create rootfs
                if [ "$ROOTFS" = "ext4" ]; then
                    msg "$FNAME Removing device nodes in NASROOT..."
                    dir_list="dev var/spool/postfix/dev var/spool-saved/postfix/dev"
                    for dir in $dir_list; do
                        [ -d $TMP_DIR/rootfs/$dir ] && rm -r $TMP_DIR/rootfs/$dir/*
                    done
                    msg "$FNAME Creating NASROOT ext4 bin file..."
                    $MAKE_EXT4FS -l `expr ${ROOT_SIZE_BYTE} / 1024 / 1024`M \
                        -L nasroot -p -s $TMP_DIR/r.bin $TMP_DIR/rootfs && sync && \
                        $SIMG2IMG $TMP_DIR/r.bin $TMP_DIR/$ROOT_IMG_NAME && sync && \
                        $E2FSCK_PATH -f -p $TMP_DIR/$ROOT_IMG_NAME && sync && \
                        $RESIZE2FS_PATH -M $TMP_DIR/$ROOT_IMG_NAME && \
                        good "done!" || error "failed!"
                else
                    error "$FNAME Only support ext4 root for NOR flash!" && exit 1
                fi
            fi
        ;;
        *)
                do_usage
                exit 1
esac

# Move generated image to pkgfile
for img in "$TMP_DIR/$ETC_IMG_NAME" "$TMP_DIR/$ROOT_IMG_NAME"; do
    [ -f $img ] && mv $img $TMP_DIR/pkgfile/omv/
done
