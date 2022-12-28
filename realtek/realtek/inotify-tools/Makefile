#
# Copyright (C) 2009 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=inotify-tools

PKG_VERSION:=3.14
PKG_MD5SUM:=b43d95a0fa8c45f8bab3aec9672cf30c

PKG_RELEASE:=1

PKG_SOURCE:=inotify-tools-$(PKG_VERSION).tar.gz
PKG_SOURCE_URL:=http://github.com/downloads/rvoicilas/inotify-tools/

PKG_INSTALL:=1
PKG_BUILD_PARALLEL:=1

include $(INCLUDE_DIR)/package.mk

define Package/inotify-tools
  SECTION:=utils
  CATEGORY:=Utilities
  SUBMENU:=Filesystem
  DEPENDS:=
  TITLE:=Inotify Tools
  URL:=
endef

define Package/inotify-tools/description
 Inotify-Tools
endef


define Package/inotify-tools/install
	$(INSTALL_DIR) $(1)/usr/bin
	$(INSTALL_BIN) $(PKG_INSTALL_DIR)/usr/bin/inotifywait $(1)/usr/bin
	$(INSTALL_BIN) $(PKG_INSTALL_DIR)/usr/bin/inotifywatch $(1)/usr/bin
	$(INSTALL_DIR) $(1)/usr/lib
	$(INSTALL_BIN) $(PKG_INSTALL_DIR)/usr/lib/libinotifytools.so.0 $(1)/usr/lib
	$(INSTALL_DIR) $(1)/usr/local/sbin
	$(INSTALL_BIN) ./files/watchhome.sh $(1)/usr/local/sbin
	$(INSTALL_DIR) $(1)/etc
	$(INSTALL_DATA) ./files/threshold $(1)/etc
endef

$(eval $(call BuildPackage,inotify-tools))
