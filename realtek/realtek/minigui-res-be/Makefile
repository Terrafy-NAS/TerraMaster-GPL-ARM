#
# Copyright (C) 2006-2015 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=minigui-res-be
PKG_VERSION:=3.0.12
PKG_RELEASE:=1

PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION).tar.gz
PKG_SOURCE_URL:=http://www.minigui.org/downloads/
PKG_MD5SUM:=c3ec3552d9ec35b987839932a5db1fcf

PKG_LICENSE:=GPLv3
PKC_LICENSE_FILES:=COPYING

PKG_FIXUP:=autoreconf
PKG_INSTALL:=1

include $(INCLUDE_DIR)/package.mk

define Package/minigui-res-be
  SECTION:=multimedia
#  CATEGORY:=Realtek NAS
#  SUBMENU:=Multimedia
  TITLE:=MiniGUI RES
  URL:=http://www.minigui.org
endef

define Build/Configure
	$(call Build/Configure/Default, \
		--prefix=/usr/ \
		--host= \
	)
endef

define Build/Compile
	$(MAKE) -C $(PKG_BUILD_DIR) \
		DESTDIR="$(PKG_INSTALL_DIR)" \
		install
endef



define Package/minigui-res-be/install
	$(INSTALL_DIR) $(1)/usr/share
	$(CP) $(PKG_INSTALL_DIR)/usr/share/* $(1)/usr/share/
endef

$(eval $(call BuildPackage,minigui-res-be))
