#
# Copyright (C) 2012 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#
include $(TOPDIR)/rules.mk
include $(INCLUDE_DIR)/image.mk
include $(INCLUDE_DIR)/host.mk
include $(CURDIR)/Makefile.in
-include $(CURDIR)/../$(SUBTARGET)/Makefile.in

DTS_FILE:=$(DTS_DIR)rtd-119x-$(call tolower, $(PROFILE)).dts
RESCUE_DTS_FILE:=$(DTS_DIR)rtd-119x-$(call tolower, $(PROFILE))-rescue.dts

ifeq ($(wildcard $(DTS_FILE)),)
DTS_FILE:=$(DTS_DIR)rtd-119x-horseradish.dts
endif

ifeq ($(wildcard $(RESCUE_DTS_FILE)),)
RESCUE_DTS_FILE:=$(DTS_DIR)rtd-119x-qa-rescue.dts
endif


ifeq ($(SUBTARGET), mnas_emmc)
$(shell sed -i 's/linux,initrd-start = <0x02200000>;/\/\/linux,initrd-start = <0x02200000>;/g' $(DTS_FILE))
$(shell sed -i 's/linux,initrd-end = <0x02600000>;/\/\/linux,initrd-end = <0x02600000>;/g' $(DTS_FILE))
else ifeq ($(CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE), y)
DTS_FILE:=$(DTS_DIR)rtd-119x-nas.dts
RESCUE_DTS_FILE:=$(DTS_DIR)rtd-119x-nas-rescue.dts
ifeq ($(SUBTARGET), emmc)
# always enable UAS on eMMC board for demo purpose
$(shell sed -i 's/fixed_port = <1>;/fixed_port = <0>;/g' $(DTS_FILE))
endif
else
$(shell sed -i 's/linux,initrd-end = <0x02e00000>;/linux,initrd-end = <0x02600000>;/g' $(RESCUE_DTS_FILE))
endif

DTB_FILE:=$(patsubst %.dts,%.dtb,$(DTS_FILE))
RESCUE_DTB_FILE:=$(patsubst %.dts,%.dtb,$(RESCUE_DTS_FILE))

UIMAGE_PATH:=$(LINUX_DIR)/arch/$(LINUX_KARCH)/boot/uImage
UIMAGE_FILE:=$(if $(wildcard $(UIMAGE_PATH)), $(UIMAGE_PATH), $(KERNEL_BUILD_DIR)/uImage)
MODULES_SUBDIR:=`cat $(LINUX_DIR)/include/config/kernel.release`
TARGET_MODULES_DIR:=$(TARGET_DIR)/lib/modules/$(MODULES_SUBDIR)
AUDIO_FW:=$(TOPDIR)/../image_file/dailybuild/QA141201/package5/bluecore.audio.zip
MALI_DIR:=$(TOPDIR)/../phoenix/system/src/drivers/gpu/mali
MALI_KO:=$(shell [ -d $(MALI_DIR) ] && find $(MALI_DIR) -name *.ko)
WIFI_DIR:=$(KERNEL_BUILD_DIR)/ottwifi-*
WIFI_KO:=$(shell [ -d $(WIFI_DIR) ] && find $(WIFI_DIR) -name *.ko)

ANDROID_OUT_DIR:=$(if $(shell [[ "$(CONFIG_TARGET_NAS_IMG_ANDROID_OUT_DIR)" = /* ]] && echo 1)\
    ,$(CONFIG_TARGET_NAS_IMG_ANDROID_OUT_DIR),$(TOPDIR)/$(CONFIG_TARGET_NAS_IMG_ANDROID_OUT_DIR))
ANDROID_PRODUCT_OUT:=$(ANDROID_OUT_DIR)/$(CONFIG_TARGET_NAS_IMG_ANDROID_TARGET_PATH)
ANDROID_HOST_OUT:=$(ANDROID_OUT_DIR)/host/linux-x86

IMG_NAME:=image_file
IMG_REV:=1007388
IMG_VERSION:=r$(IMG_REV)

-include $(CURDIR)/image-dl.mk

IMAGE_DIR:=$(CURDIR)/$(IMG_NAME)-$(IMG_VERSION)/packages/omv
EMMC_PARTITION_LAYOUT:=$(IMAGE_DIR)/customer/rtk_generic_emmc_nas/partition.txt
MNAS_EMMC_PARTITION_LAYOUT:=$(IMAGE_DIR)/customer/rtk_generic_emmc/partition.txt

#       find $(LINUX_DIR) $(EXT_DRIVERS) -name "*.ko" | xargs -i cp {} $(TARGET_MODULES_DIR)

ifeq ($(CONFIG_RTKWIFIU_CONCURRENT_MODE),y)
define Image/Prepare/Setconfig
	$(CP) ../conf/wireless.rtkwifi2 $(TARGET_DIR)/etc/config/wireless
endef
else ifeq ($(CONFIG_PACKAGE_kmod-rtkwifiu),y)
define Image/Prepare/Setconfig
	$(CP) ../conf/wireless.rtkwifi1 $(TARGET_DIR)/etc/config/wireless
endef
else
define Image/Prepare/Setconfig
	rm -f $(TARGET_DIR)/etc/config/wireless
endef
endif

define Image/Build/Profile/HorseradishV2
	sed -i 's|^.*\(part.*rootfs.*squashfs.*\)|#\1|g;s|^.*\(part.*rootfs.*ext4.*\)|\1|g' $(EMMC_PARTITION_LAYOUT)
endef

define Image/Build/Profile/Horseradish
	sed -i 's|^.*\(part.*rootfs.*ext4.*\)|#\1|g;s|^.*\(part.*rootfs.*squashfs.*\)|\1|g' $(EMMC_PARTITION_LAYOUT)
endef

define Image/Build/Profile/MediaNAS
	sed -i 's|^.*\(part.*rootfs.*ext4.*\)|#\1|g;s|^.*\(part.*rootfs.*squashfs.*\)|\1|g' $(MNAS_EMMC_PARTITION_LAYOUT)
endef

define Image/Build/Rtd1195
	$(CP) $(UIMAGE_FILE) $(IMAGE_DIR)/$(layout_type).uImage
	$(CP) $(DTB_FILE) $(IMAGE_DIR)/android.$(layout_type).dtb
	$(CP) $(RESCUE_DTB_FILE) $(IMAGE_DIR)/rescue.$(layout_type).dtb

	$(call Image/mkfs/prepare)
	$(TAR) -cvjBpf $(IMAGE_DIR)/root.$(layout_type).tar.bz2  --numeric-owner --owner=0 --group=0 -C $(TARGET_DIR)/ .

	if [ "$(layout_type)" = "nand" ]; then \
	    sed -i -r "s/^NAND_PAGE_SIZE=[0-9]+.*/NAND_PAGE_SIZE=$(NAND_PAGE_SIZE)/g" $(IMAGE_DIR)/Makefile.in; \
	    sed -i -r "s/^NAND_BLOCK_SIZE=[0-9]+.*/NAND_BLOCK_SIZE=$(NAND_BLOCK_SIZE)/g" $(IMAGE_DIR)/Makefile.in; \
	fi

	(cd $(IMG_NAME)-$(IMG_VERSION); \
	    make TARGET=$(PACKAGES) layout_type=$(layout_type) layout_size=$(layout_size) \
	    ANDROID_IMGS=$(ANDROID_IMGS) install_bootloader=$(install_bootloader) \
	    install_factory=$(install_factory) update_etc=$(update_etc) logger_level=$(logger_level) \
	    hash_imgfile=$(hash_imgfile) verify=$(verify) \
	    F_EXT=$(F_EXT) \
	    ; \
	    cd -)
	/bin/mv install.img $(BIN_DIR)
endef

ifeq ($(SUBTARGET),mnas_emmc)
AUDIO_FW_NAME:=bluecore.audio.zip
else
AUDIO_FW_NAME:=nas.bluecore.audio.zip
endif
# Android: $(TOPDIR)/../android
# mali: $(MALI_KO), $(KERNEL_BUILD_DIR)/mali/*.ko
# audio fw: $(AUDIO_FW), $(CURDIR)/files/bluecore.audio.zip
define Image/Build/nas
	if [ "$(SUBTARGET)" = "mnas_emmc" ]; then \
	    [ ! -d "$(IMAGE_DIR)/root" ] && ln -sf $(ANDROID_PRODUCT_OUT)/root $(IMAGE_DIR)/root; \
	    [ ! -d "$(IMAGE_DIR)/system" ] && ln -sf $(ANDROID_PRODUCT_OUT)/system $(IMAGE_DIR)/system; \
	    if [ "$(MALI_KO)" != "" ]; then \
	        mkdir -p $(KERNEL_BUILD_DIR)/mali; \
	        cp $(MALI_KO) $(KERNEL_BUILD_DIR)/mali; \
	    fi; \
	    [ -d "$(KERNEL_BUILD_DIR)/mali" ] && \
	        cp $(KERNEL_BUILD_DIR)/mali/*.ko $(IMAGE_DIR)/system/vendor/modules/; \
	    if [ "$(CONFIG_PACKAGE_kmod-cfg80211)" == "" ]; then \
		cp $(WIFI_KO) $(IMAGE_DIR)/system/vendor/modules/; \
	    fi; \
	    chmod 644 $(IMAGE_DIR)/system/vendor/modules/*.ko; \
	    if [ -f "$(AUDIO_FW)" ]; then \
	        diff $(AUDIO_FW) $(IMAGE_DIR) || \
	            $(CP) $(AUDIO_FW) $(CURDIR)/files/$(AUDIO_FW_NAME); \
	    fi; \
	fi
	-[ -f "$(CURDIR)/files/$(AUDIO_FW_NAME)" ] && \
	    $(CP) $(CURDIR)/files/$(AUDIO_FW_NAME) $(IMAGE_DIR)/bluecore.audio.zip
	$(call Image/Build/Profile/$(PROFILE),$(1))
	$(call Image/BuildDTB, $(DTS_FILE),$(DTB_FILE),"-p 8192")
	$(call Image/BuildDTB, $(patsubst %.dtb,%.dts,$(RESCUE_DTB_FILE)),$(RESCUE_DTB_FILE),"-p 8192")
	$(call Image/Build/Rtd1195,$(1))
endef

define Image/Prepare
	$(call Image/Prepare/Setconfig)
endef

define Image/Build
	$(if $(Image/Build/$(1)), \
		$(call Image/Build/$(1),$(1))
	)
endef

$(eval $(call BuildImage))
