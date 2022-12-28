#
# Copyright (C) 2015-2016 Realtek
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=u-boot
PKG_VERSION:=2017.09
PKG_RELEASE:=3
RELEASE_DATE:=2017.10

PKG_SOURCE_PROTO:=git
PKG_SOURCE_URL:=
PKG_SOURCE_SUBDIR:=$(PKG_NAME)-$(PKG_VERSION)
PKG_SOURCE_BRANCH:=20180207
PKG_SOURCE_VERSION:=7117641d
PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION)-$(PKG_SOURCE_VERSION).tar.gz

include $(INCLUDE_DIR)/package.mk

TARGET_CFLAGS+=

define Package/u-boot
  SECTION:=boot
  CATEGORY:=Boot Loaders
  DEPENDS:=@TARGET_rtl8117
  TITLE:=Das U-Boot
endef

define Package/u-boot/description
 Das U-Boot -- the Universal Boot Loader
endef

define Build/Prepare
	rm -rf $(PKG_BUILD_DIR)
	-git clean -f -d $(TOPDIR)/u-boot
	-git checkout -- $(TOPDIR)/u-boot
	ln -s $(TOPDIR)/u-boot $(PKG_BUILD_DIR)
endef

define Build/Configure
	$(MAKE) -C $(PKG_BUILD_DIR) rtl8117_defconfig
endef

define Build/Compile
	$(MAKE) -C $(PKG_BUILD_DIR) CROSS_COMPILE=$(TARGET_CROSS) TARGET_CFLAGS="$(TARGET_CFLAGS)"
	$(MAKE) -C $(PKG_BUILD_DIR) CROSS_COMPILE=$(TARGET_CROSS) TARGET_CFLAGS="$(TARGET_CFLAGS)" envtools
endef

define Package/u-boot/install
	$(SCRIPT_DIR)/ipkg-extract $(PKG_NAME) "$(1)" "$(TOPDIR)/packages"
	$(INSTALL_DIR) $(BIN_DIR)
	$(CP) $(PKG_BUILD_DIR)/8117.bin $(BIN_DIR)/openwrt-$(BOARD)-bootcode.bin
	$(INSTALL_DIR) $(1)/usr/sbin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/tools/env/fw_printenv $(1)/usr/sbin
	$(LN) fw_printenv $(1)/usr/sbin/fw_setenv
	$(INSTALL_DIR) $(1)/lib
	$(INSTALL_DATA) ./files/uboot-envtools.sh $(1)/lib
	$(INSTALL_DIR) $(1)/etc
endef

$(eval $(call BuildPackage,u-boot))
