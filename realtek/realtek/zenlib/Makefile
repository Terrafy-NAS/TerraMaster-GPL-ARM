#
# Copyright (C) 2017 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=zenlib
PKG_VERSION:=0.7.97
PKG_RELEASE:=1

PKG_SOURCE_PROTO:=git
PKG_SOURCE_URL:=https://github.com/MediaArea/ZenLib.git
PKG_SOURCE_SUBDIR:=$(PKG_NAME)-$(PKG_VERSION)
PKG_SOURCE_VERSION:=HEAD
PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION).tar.bz2

include $(INCLUDE_DIR)/package.mk

define Package/zenlib
  SECTION:=utilities
  CATEGORY:=Multimedia
  TITLE=Zenlib for MediaInfo
  URL:=https://mediaarea.net/en/MediaInfo
  DEPENDS:=+libstdcpp
endef

#DEPENDS:=+libc +SSP_SUPPORT:libssp +USE_GLIBC:librt +USE_GLIBC:libpthread  +zlib

define Package/zenlib/description
  Zenlib is a library for MediaInfo
endef

CONFIGURE_PATH:=Project/GNU/Library

define Build/Configure
	(cd $(PKG_BUILD_DIR)/$(CONFIGURE_PATH); ./autogen.sh; $(call Build/Configure/Default, --enable-static))
endef

define Build/Compile
	$(MAKE) -C $(PKG_BUILD_DIR)/Project/GNU/Library CROSS_COMPILE=$(TARGET_CROSS) TARGET_CFLAGS="$(TARGET_CFLAGS)"
endef

define Build/InstallDev
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/$(CONFIGURE_PATH)/libzen-config $(STAGING_DIR)/host/bin/
	$(INSTALL_DIR) $(1)/usr/include/ZenLib
	$(INSTALL_DATA) $(PKG_BUILD_DIR)/Source/ZenLib/*.h $(1)/usr/include/ZenLib
	$(INSTALL_DIR) $(1)/usr/include/ZenLib/Format/Http
	$(INSTALL_DATA) $(PKG_BUILD_DIR)/Source/ZenLib/Format/Http/*.h $(1)/usr/include/ZenLib/Format/Http
endef

define Package/zenlib/install
	$(INSTALL_DIR) $(1)/usr/lib
	$(INSTALL_DATA) $(PKG_BUILD_DIR)/$(CONFIGURE_PATH)/.libs/libzen.so.0.0.0 $(1)/usr/lib
	$(LN) libzen.so.0.0.0 $(1)/usr/lib/libzen.so
	$(LN) libzen.so.0.0.0 $(1)/usr/lib/libzen.so.0
endef

$(eval $(call BuildPackage,zenlib))
