#
# Copyright (C) 2015-2016 Realtek
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk
include $(INCLUDE_DIR)/target.mk

PKG_NAME:=u-boot64
PKG_VERSION:=3655658
RELEASE_DATE:=$(shell date +%Y%m%d)
PKG_RELEASE:=1

PKG_SOURCE_PROTO:=git
PKG_SOURCE_URL:=
PKG_SOURCE_BRANCH:=uboot64_1295
PKG_SOURCE_VERSION:=$(PKG_VERSION)
PKG_SOURCE_SUBDIR:=$(PKG_NAME)-$(PKG_VERSION)
PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION).tar.bz2
PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_NAME)-$(PKG_VERSION)

PKG_CONFIG_DEPENDS:= \
	CONFIG_TARGET_NAS_IMG_DUAL_BOOT \
	CONFIG_RTK_BOARD_MTD_LAYOUT \
	CONFIG_RTK_BOARD_CHIP_1295  \
	CONFIG_RTK_BOARD_CHIP_1296  \
	CONFIG_RTK_BOARD_DDR_1GB \
	CONFIG_RTK_BOARD_DDR_2GB \
	CONFIG_RTK_BOARD_DDR_3GB \
	CONFIG_UBoot_CHIP_A  \
	CONFIG_UBoot_CHIP_B  \
	CONFIG_UBoot_DDR3  \
	CONFIG_UBoot_DDR4  \
	CONFIG_UBoot_DDR_1600 \
	CONFIG_UBoot_DDR_1866 \
	CONFIG_UBoot_DDR_2133

include $(INCLUDE_DIR)/package.mk

ifeq ($(DUMP),)
ifneq ($(CONFIG_RTK_BOARD_MTD_LAYOUT),)
  STAMP_CONFIGURED:=$(strip $(STAMP_CONFIGURED))_$(shell $(SH_FUNC) echo $(CONFIG_RTK_MTD_UBOOT_SIZE)$(CONFIG_RTK_MTD_ROOTFS_SIZE)$(CONFIG_RTK_MTD_KERNEL_SIZE)$(CONFIG_RTK_MTD_DTB_SIZE)$(CONFIG_RTK_MTD_AFW_SIZE)$(CONFIG_RTK_MTD_LOGO_SIZE) | md5s)
endif
endif

HW_SETTING=$(CONFIG_UBoot_BOARD)_hwsetting_BOOT_$(CONFIG_UBoot_DDR_BANK)$(CONFIG_UBoot_DDR_TYPE)_$(CONFIG_UBoot_DDR_SIZE)_s$(CONFIG_UBoot_DDR_FREQ)
LOWER_BOARD_NAME=`echo $(CONFIG_UBoot_BOARD) | tr A-Z a-z`
layout_type?=$(subst .,,$(suffix $(subst _,.,$(SUBTARGET))))

ifneq ($(CONFIG_TARGET_NAS_IMG_DUAL_BOOT),)
  OPT:=KCFLAGS="-DNAS_DUAL"
else ifneq ($(CONFIG_RTK_BOARD_MTD_LAYOUT),)
  OPT:='KCFLAGS=-D CONFIG_UBOOT_SIZE=$(shell printf '0x%X' "$$(($(CONFIG_RTK_MTD_UBOOT_SIZE)*1024))") \
               -D CONFIG_FWIMG_ADDR=$(shell printf '0x%X' "$$(($(CONFIG_RTK_MTD_UBOOT_SIZE)*1024+0x20000))") \
               -D CONFIG_FWIMG_SIZE=$(shell printf '0x%X' "$$(($(CONFIG_RTK_MTD_ROOTFS_SIZE)*1024+$(CONFIG_RTK_MTD_KERNEL_SIZE)*1024+$(CONFIG_RTK_MTD_DTB_SIZE)*1024+$(CONFIG_RTK_MTD_AFW_SIZE)*1024+$(CONFIG_RTK_MTD_LOGO_SIZE)*1024))") \
               -D CONFIG_ROOTFS_SIZE=$(CONFIG_RTK_MTD_ROOTFS_SIZE)*1024 \
               -D CONFIG_KERNEL_SIZE=$(CONFIG_RTK_MTD_KERNEL_SIZE)*1024 \
               -D CONFIG_DTS_SIZE=$(CONFIG_RTK_MTD_DTB_SIZE)*1024 \
               -D CONFIG_AFW_SIZE=$(CONFIG_RTK_MTD_AFW_SIZE)*1024 \
               -D CONFIG_LOGO_SIZE=$(CONFIG_RTK_MTD_LOGO_SIZE)*1024'
else ifeq ($(layout_type),spi)
  OPT:=KCFLAGS="-D CONFIG_BOOT_FROM_SPI=y"
endif

TARGET_CFLAGS+=

define Package/u-boot64
  SECTION:=boot
  CATEGORY:=Boot Loaders
  DEPENDS:=@TARGET_rtd1295
  TITLE:=Das U-Boot
endef

define Package/u-boot64/description
 Das U-Boot -- the Universal Boot Loader
endef

define Package/u-boot64/config
        source "$(SOURCE)/Config.in"
endef

define Build/Prepare
	rm -rf $(PKG_BUILD_DIR)
	-git clean -f -d $(TOPDIR)/u-boot64
	-git checkout -- $(TOPDIR)/u-boot64
	ln -s $(TOPDIR)/u-boot64 $(PKG_BUILD_DIR)
	$(Build/Patch)
endef

define Build/Configure
endef

define Build/Compile
	$(MAKE) -C $(PKG_BUILD_DIR) distclean
	$(MAKE) -C $(PKG_BUILD_DIR) mrproper
ifeq ($(layout_type),spi)
	$(MAKE) -C $(PKG_BUILD_DIR) $(LOWER_BOARD_NAME)_spi_defconfig
else ifeq ($(layout_type),nand)
	$(MAKE) -C $(PKG_BUILD_DIR) $(LOWER_BOARD_NAME)_nand_NAS_defconfig
else
	$(MAKE) -C $(PKG_BUILD_DIR) $(LOWER_BOARD_NAME)_qa_NAS_defconfig
endif
	$(MAKE) -C $(PKG_BUILD_DIR) Board_HWSETTING=$(HW_SETTING) CROSS_COMPILE=$(TARGET_CROSS) $(OPT) CONFIG_CHIP_TYPE=$(CONFIG_UBoot_CHIP_TYPE)
ifneq ($(CONFIG_PACKAGE_u-boot64_envtools),)
	$(MAKE) -C $(PKG_BUILD_DIR) CROSS_COMPILE=$(TARGET_CROSS) TARGET_CFLAGS="$(TARGET_CFLAGS)" env
endif
endef

define Package/u-boot64/install
	$(INSTALL_DIR) $(BIN_DIR)/$(PKG_NAME)
	$(CP) $(PKG_BUILD_DIR)/examples/flash_writer/image/hw_setting/$(HW_SETTING).bin $(BIN_DIR)/$(PKG_NAME)
	$(CP) $(PKG_BUILD_DIR)/examples/flash_writer/dvrboot.exe.bin \
	    $(BIN_DIR)/$(PKG_NAME)/NAS_$(CONFIG_UBoot_BOARD)_$(layout_type)_$(CONFIG_UBoot_DDR_BANK)x$(CONFIG_UBoot_DDR_SIZE)_$(CONFIG_UBoot_DDR_TYPE)_$(CONFIG_UBoot_DDR_FREQ).bin
ifneq ($(CONFIG_RTK_BOARD_MTD_LAYOUT),)
	$(CP) $(PKG_BUILD_DIR)/examples/flash_writer/Bind/bind.bin \
	    $(BIN_DIR)/$(PKG_NAME)/NAS_$(CONFIG_UBoot_BOARD)_$(layout_type)_$(CONFIG_UBoot_DDR_BANK)x$(CONFIG_UBoot_DDR_SIZE)_$(CONFIG_UBoot_DDR_TYPE)_$(CONFIG_UBoot_DDR_FREQ)_raw.bin
	$(LN) NAS_$(CONFIG_UBoot_BOARD)_$(layout_type)_$(CONFIG_UBoot_DDR_BANK)x$(CONFIG_UBoot_DDR_SIZE)_$(CONFIG_UBoot_DDR_TYPE)_$(CONFIG_UBoot_DDR_FREQ)_raw.bin $(BIN_DIR)/$(PKG_NAME)/openwrt-$(BOARD)-bootcode.bin
endif
ifneq ($(CONFIG_PACKAGE_u-boot64_envtools),)
	$(INSTALL_DIR) $(1)/usr/sbin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/tools/env/fw_printenv $(1)/usr/sbin
	$(LN) fw_printenv $(1)/usr/sbin/fw_setenv
	$(INSTALL_DIR) $(1)/lib
	$(INSTALL_DATA) ./files/uboot-envtools.sh $(1)/lib
	$(INSTALL_DIR) $(1)/etc/uci-defaults
	$(INSTALL_DATA) ./files/rtd1295 $(1)/etc/uci-defaults/30_uboot-envtools
endif
endef

$(eval $(call BuildPackage,u-boot64))
