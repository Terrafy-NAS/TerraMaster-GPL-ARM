#
# Copyright (C) 2008-2010 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=wayland-protocols
PKG_VERSION:=1.8
PKG_RELEASE:=1

PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION).tar.xz
PKG_SOURCE_URL:=https://wayland.freedesktop.org/releases/
PKG_MD5SUM:=769f93b312b1323a8012565c3973cf7d
PKG_INSTALL:=1

include $(INCLUDE_DIR)/package.mk

define Package/wayland-protocols
  SECTION:=xorg-framework
  CATEGORY:=Xorg
  SUBMENU:=proto
  TITLE:=Wayland-protocols
  URL:=http://wayland.freedesktop.org/
endef

define Package/wayland-protocols/description
	The Wayland-Protocols package contains additional Wayland
	protocols that add functionality outside of protocols 
	already in the Wayland core. 
endef

define Build/InstallDev
	$(INSTALL_DIR) $(1)/usr
	$(CP) $(PKG_INSTALL_DIR)/usr/* $(1)/usr/
	$(INSTALL_DIR) $(1)/usr/lib/pkgconfig
	$(CP) $(PKG_INSTALL_DIR)/usr/share/pkgconfig/*.pc $(1)/usr/lib/pkgconfig
endef

define Package/wayland-protocols/install
	$(INSTALL_DIR) $(1)/usr
	$(CP) $(PKG_INSTALL_DIR)/usr/* $(1)/usr/
endef

$(eval $(call BuildPackage,wayland-protocols))
