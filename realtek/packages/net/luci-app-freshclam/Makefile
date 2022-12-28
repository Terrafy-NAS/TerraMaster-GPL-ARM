#
# Copyright (C) 2015 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=luci-app-freshclam
PKG_RELEASE:=20150520

PKG_BUILD_DIR := $(BUILD_DIR)/$(PKG_NAME)

PKG_LICENSE:=Apache-2.0
PKG_MAINTAINER:=Marko Ratkaj <marko.ratkaj@sartura.hr>

include $(INCLUDE_DIR)/package.mk

define Package/luci-app-freshclam
  SECTION:=luci
  CATEGORY:=LuCI
  SUBMENU:=3. Applications
  TITLE:=Freshclam Web UI
  DEPENDS:=+luci-mod-admin-full +freshclam
endef

define Package/luci-app-freshclam/description
 This package will install Freshclam Web UI.
endef

define Build/Prepare
endef

define Build/Configure
endef

define Build/Compile
endef

define Package/luci-app-freshclam/install
	$(INSTALL_DIR) $(1)/usr/lib/lua/luci/controller/
	$(INSTALL_BIN) \
		./files/controller/freshclam-controller.lua \
		$(1)/usr/lib/lua/luci/controller/freshclam.lua

	$(INSTALL_DIR) $(1)/usr/lib/lua/luci/model/cbi/
	$(INSTALL_BIN) \
		./files/model/cbi/freshclam-cbi.lua \
		$(1)/usr/lib/lua/luci/model/cbi/freshclam.lua
endef

$(eval $(call BuildPackage,luci-app-freshclam))
