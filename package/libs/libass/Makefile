#
# Copyright (C) 2008-2012 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=libass
PKG_VERSION:=0.10.2
PKG_RELEASE:=1

PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION).tar.xz
PKG_SOURCE_URL:=https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/libass/
PKG_MD5SUM:=ce672ed5629c9708b3401b976f516744

PKG_FIXUP:=autoreconf
PKG_INSTALL:=1

PKG_MAINTAINER:=Felix Fietkau <nbd@openwrt.org>
PKG_LICENSE:=LGPL-2.1+

include $(INCLUDE_DIR)/package.mk

define Package/libass
  SECTION:=libs
  CATEGORY:=Libraries
  TITLE:=Subtitle renderer for the ASS/SSA
  DEPENDS:=+libfribidi +fontconfig +libfreetype
  URL:=http://www.linuxfromscratch.org/blfs/view/8.0/multimedia/libass.html
endef

define Package/libass/description
  provides the functions used to render ASS/SSA subtitle format.
endef

CONFIGURE_ARGS += \
	--enable-shared \
	--disable-static \
	--disable-cxx

define Build/InstallDev
	$(CP) $(PKG_INSTALL_DIR)/* $(1)/
endef

define Package/libass/install
	$(INSTALL_DIR) $(1)/usr/lib
	$(CP) $(PKG_INSTALL_DIR)/usr/lib/libass.so* $(1)/usr/lib/
endef

$(eval $(call BuildPackage,libass))
