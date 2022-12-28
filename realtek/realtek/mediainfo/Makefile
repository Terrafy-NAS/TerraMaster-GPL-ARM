#
# Copyright (C) 2017 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=mediainfo
PKG_VERSION:=0.7.97
PKG_RELEASE:=1

PKG_SOURCE_PROTO:=git
PKG_SOURCE_URL:=https://github.com/MediaArea/MediaInfo.git
PKG_SOURCE_SUBDIR:=$(PKG_NAME)-$(PKG_VERSION)
PKG_SOURCE_VERSION:=HEAD
PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION).tar.bz2

include $(INCLUDE_DIR)/package.mk

define Package/mediainfo
  SECTION:=utilities
  CATEGORY:=Multimedia
  TITLE=MediaInfo from MediaArea
  URL:=https://mediaarea.net/en/MediaInfo
  DEPENDS:=+zenlib +libmediainfo
endef

define Package/mediainfo/description
  MediaInfo provides information on a variety of video and audio files
endef

CONFIGURE_PATH:=Project/GNU/CLI

define Build/Configure
	(cd $(PKG_BUILD_DIR)/$(CONFIGURE_PATH); ./autogen.sh; $(call Build/Configure/Default, --enable-shared))
endef

define Build/Compile
	$(MAKE) -C $(PKG_BUILD_DIR)/$(CONFIGURE_PATH) CROSS_COMPILE=$(TARGET_CROSS) TARGET_CFLAGS="$(TARGET_CFLAGS)"
endef

define Package/mediainfo/install
	$(INSTALL_DIR) $(1)/usr/bin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/$(CONFIGURE_PATH)/.libs/mediainfo $(1)/usr/bin
endef

$(eval $(call BuildPackage,mediainfo))
