#
# Copyright (C) 2006-2015 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=libmgplus
PKG_VERSION:=1.2.4
PKG_RELEASE:=1

PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION).tar.gz
PKG_SOURCE_URL:=http://www.minigui.org/downloads/
PKG_MD5SUM:=3185eb8c1b02a12ddfe20828008fa129

PKG_LICENSE:=GPLv3
PKC_LICENSE_FILES:=COPYING

PKG_FIXUP:=autoreconf
PKG_INSTALL:=1
PKG_BUILD_DEPENDS:=libminigui-gpl
include $(INCLUDE_DIR)/package.mk

define Package/libmgplus
  SECTION:=multimedia
#  CATEGORY:=Realtek NAS
#  SUBMENU:=Multimedia
  DEPENDS:=+libminigui-gpl +libstdcpp
  TITLE:=Minigui Plus
  URL:=http://www.minigui.org
endef


define Build/Configure
	$(call Build/Configure/Default, \
		--prefix=/usr \
	)
endef

define Build/Compile
	$(MAKE) -C $(PKG_BUILD_DIR) \
		DESTDIR="$(PKG_INSTALL_DIR)" \
		install
endef

define Build/InstallDev
	mkdir -p $(1)/usr/include/
	$(CP)	$(PKG_INSTALL_DIR)/usr/include/mgplus \
		$(1)/usr/include/
	mkdir -p $(1)/usr/lib
	$(CP)	$(PKG_INSTALL_DIR)/usr/lib/libmgplus.{a,la,so} \
		$(1)/usr/lib/
	$(CP)	$(PKG_INSTALL_DIR)/usr/lib/libmgplus-1.2.4.so.* \
		$(1)/usr/lib/
	mkdir -p $(1)/usr/lib/pkgconfig
	$(CP)	$(PKG_INSTALL_DIR)/usr/lib/pkgconfig/mgplus.pc \
		$(1)/usr/lib/pkgconfig/
endef

define Package/libmgplus/install
	$(INSTALL_DIR) $(1)/usr/lib
	$(CP) $(PKG_INSTALL_DIR)/usr/lib/libmgplus.so $(1)/usr/lib/
	$(CP) $(PKG_INSTALL_DIR)/usr/lib/libmgplus-1.2.4.so.* $(1)/usr/lib/
	$(INSTALL_DIR) $(1)/usr/share
	mkdir -p $(1)/usr/share/minigui
	$(CP) $(PKG_INSTALL_DIR)/usr/share/minigui/cmake $(1)/usr/share/minigui/cmake
endef

$(eval $(call BuildPackage,libmgplus))
