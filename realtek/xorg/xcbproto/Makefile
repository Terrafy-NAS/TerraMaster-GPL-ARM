#
# Copyright (C) 2008-2010 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=xcb-proto
PKG_VERSION:=1.12
PKG_RELEASE:=1

PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION).tar.bz2
PKG_SOURCE_URL:=http://xcb.freedesktop.org/dist/
PKG_MD5SUM:=14e60919f859560f28426a685a555962
PKG_INSTALL:=1

PKG_BUILD_DEPENDS:=python

include $(INCLUDE_DIR)/package.mk

define Package/xcbproto
  SECTION:=xorg-framework
  CATEGORY:=Xorg
  SUBMENU:=proto
  #BUILDONLY:=1
  TITLE:=xcbproto
  URL:=http://xcb.freedesktop.org/
  DEPENDS:=+libxml2 +python
endef

define Package/xcbproto/description
	The xcb-proto package provides the XML-XCB protocol
	descriptions that libxcb uses to generate the majority
	of its code and API.
endef

define Build/InstallDev
	$(INSTALL_DIR) \
		$(1)/usr/lib/pkgconfig \
		$(1)/host/share/xcb \
		$(1)/usr/lib/python2.7/site-packages/xcbgen

	$(INSTALL_DATA) \
		$(PKG_INSTALL_DIR)/usr/share/xcb/* \
		$(1)/host/share/xcb/

	$(INSTALL_DATA) \
		$(PKG_INSTALL_DIR)/usr/lib/pkgconfig/* \
		$(1)/usr/lib/pkgconfig/

	$(CP) \
		$(PKG_INSTALL_DIR)/usr/lib/python2.7/site-packages/xcbgen/*.* \
		$(1)/usr/lib/python2.7/site-packages/xcbgen/

	$(SED) 's,datadir=/usr,datadir=$(STAGING_DIR)/host,g' $(1)/usr/lib/pkgconfig/xcb-proto.pc
endef

$(eval $(call BuildPackage,xcbproto))
