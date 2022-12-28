# 
# Copyright (C) 2006 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#
# blogic@openwrt.org
include $(TOPDIR)/rules.mk

PKG_NAME:=xproto
PKG_RELEASE:=1
PKG_VERSION:=7.0.31
PKG_SOURCE_URL:=https://www.x.org/archive/individual/proto/
PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION).tar.bz2
PKG_BUILD_DIR=$(BUILD_DIR)/Xorg/$(_CATEGORY)/${PKG_NAME}-$(PKG_VERSION)/

include $(INCLUDE_DIR)/package.mk

define Package/xproto
  SECTION:=xorg-framework
  CATEGORY:=Xorg
  SUBMENU:=proto
  TITLE:=xproto
  URL:=http://xorg.freedesktop.org/
endef

define Build/InstallDev
	DESTDIR=$(1) $(MAKE) -C $(PKG_BUILD_DIR)/ $(MAKE_FLAGS) install
endef

define Build/Compile
	true
endef

$(eval $(call BuildPackage,xproto))
