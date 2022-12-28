#
# Copyright (C) 2017 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=libmediainfo
PKG_VERSION:=0.7.97
PKG_RELEASE:=1

PKG_SOURCE_PROTO:=git
PKG_SOURCE_URL:=https://github.com/MediaArea/MediaInfoLib.git
PKG_SOURCE_SUBDIR:=$(PKG_NAME)-$(PKG_VERSION)
PKG_SOURCE_VERSION:=HEAD
PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION).tar.bz2

include $(INCLUDE_DIR)/package.mk

define Package/libmediainfo
  SECTION:=utilities
  CATEGORY:=Multimedia
  TITLE=LibMediainfo for MediaInfo
  URL:=https://mediaarea.net/en/MediaInfo
  DEPENDS:=+zenlib +zlib
endef


define Package/libmediainfo/description
  Libmediainfo is a library for MediaInfo
endef

CONFIGURE_PATH:=Project/GNU/Library
TARGET_CFLAGS += -I$(STAGING_DIR)/usr/include

define Build/Configure
	(cd $(PKG_BUILD_DIR)/$(CONFIGURE_PATH); ./autogen.sh; $(call Build/Configure/Default, --enable-static))
endef

define Build/Compile
	$(MAKE) -C $(PKG_BUILD_DIR)/Project/GNU/Library CROSS_COMPILE=$(TARGET_CROSS) TARGET_CFLAGS="$(TARGET_CFLAGS)"
endef

define Build/InstallDev
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/$(CONFIGURE_PATH)/libmediainfo-config $(STAGING_DIR)/host/bin/
	$(INSTALL_DIR) $(1)/usr/include/MediaInfo
	$(INSTALL_DATA) $(PKG_BUILD_DIR)/Source/MediaInfo/MediaInfo*.h $(1)/usr/include/MediaInfo
endef

define Package/libmediainfo/install
	$(INSTALL_DIR) $(1)/usr/lib
	$(INSTALL_DATA) $(PKG_BUILD_DIR)/$(CONFIGURE_PATH)/.libs/libmediainfo.so.0.0.0 $(1)/usr/lib
	$(LN) libmediainfo.so.0.0.0 $(1)/usr/lib/libmediainfo.so
	$(LN) libmediainfo.so.0.0.0 $(1)/usr/lib/libmediainfo.so.0
endef

$(eval $(call BuildPackage,libmediainfo))
