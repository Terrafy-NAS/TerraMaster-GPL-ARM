#
# Copyright (C) 2018 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=rtk-tpapi
PKG_RELEASE:=1
RELEASE_DATE:=$(shell date +%Y%m%d)

PKG_SOURCE_PROTO:=git
PKG_SOURCE_URL:=ssh://cn1sd10gerrit1.realtek.com.tw:20013/TP-Link
PKG_SOURCE_SUBDIR:=$(PKG_NAME)
PKG_SOURCE_VERSION:=0abd85b5161f85d6b6dd59816236c41c20d7ad81
PKG_SOURCE:=rtkdl-$(PKG_NAME).tar.gz

PKG_FIXUP:=autoreconf
PKG_INSTALL:=1

include $(INCLUDE_DIR)/package.mk

define Package/rtk-tpapi
  SECTION:=nas
  CATEGORY:=Realtek
  TITLE:=Realtek tp API
  DEPENDS:=@TARGET_rtd1295 +rtkMediaLib rtk-nvr +supportlibs
endef

define Package/rtk-tpapi/description
 This package provides tp API for network video recorder (NVR) feature
endef

define Build/InstallDev
	# header files
	$(INSTALL_DIR) $(1)/usr/include
	$(CP) $(PKG_INSTALL_DIR)/usr/include/* $(1)/usr/include/
	# linking libraries
	$(INSTALL_DIR) $(1)/usr/lib
	$(CP) $(PKG_INSTALL_DIR)/usr/lib/lib*.{a,la,so*} $(1)/usr/lib/
	# pkg-config
	$(INSTALL_DIR) $(1)/usr/lib/pkgconfig
	$(CP) $(PKG_INSTALL_DIR)/usr/lib/pkgconfig/*.pc $(1)/usr/lib/pkgconfig/
endef

define Package/rtk-tpapi/install
	# libraries
	$(INSTALL_DIR) $(1)/usr/lib
	$(CP) $(PKG_INSTALL_DIR)/usr/lib/lib*.so* $(1)/usr/lib/
	# tests
	$(INSTALL_DIR) $(1)/root/tp
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/tests/.libs/* $(1)/root/tp/
endef

$(eval $(call BuildPackage,rtk-tpapi))
