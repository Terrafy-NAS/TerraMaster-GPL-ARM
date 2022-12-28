#
# Copyright (C) 2008-2012 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=fribidi
PKG_VERSION:=0.19.7
PKG_RELEASE:=1

PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION).tar.bz2
PKG_SOURCE_URL:=https://ftp.osuosl.org/pub/blfs/conglomeration/fribidi
PKG_MD5SUM:=6c7e7cfdd39c908f7ac619351c1c5c23

PKG_FIXUP:=autoreconf
PKG_INSTALL:=1

PKG_MAINTAINER:=Felix Fietkau <nbd@openwrt.org>
PKG_LICENSE:=LGPL-2.1+

include $(INCLUDE_DIR)/package.mk

define Package/libfribidi
  SECTION:=libs
  CATEGORY:=Libraries
  TITLE:=Unicode Bidirectional Algorithm
  DEPENDS:=+glib2
  URL:=http://www.linuxfromscratch.org/blfs/view/cvs/general/fribidi.html
endef

define Package/libass/description
  Contains functions used to implement the Unicode Bidirectional Algorithm
endef

CONFIGURE_ARGS += \
	--enable-shared \
	--disable-static \
	--disable-cxx

define Build/InstallDev
	$(CP) $(PKG_INSTALL_DIR)/* $(1)/
endef

define Package/libfribidi/install
	$(INSTALL_DIR) $(1)/usr/lib
	$(CP) $(PKG_INSTALL_DIR)/usr/lib/libfribidi.so* $(1)/usr/lib/
endef

$(eval $(call BuildPackage,libfribidi))
