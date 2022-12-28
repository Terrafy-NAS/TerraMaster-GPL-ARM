#
# Copyright (C) 2016 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=rtwpriv
#PKG_VERSION:=2017
PKG_RELEASE:=1

PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_NAME)

include $(INCLUDE_DIR)/package.mk
define Package/rtwpriv
  SECTION:=net
  CATEGORY:=Network
  TITLE:=Realtek WiFi Config utility
  DEPENDS:=
endef
define Package/rtwpriv/description
	Realtek wifi configuration tool
endef
define Build/Prepare
endef

define Build/Compile
endef

define Build/InstallDev

endef

define Package/rtwpriv/install
	$(SCRIPT_DIR)/ipkg-extract $(PKG_NAME) "$(1)" "$(TOPDIR)/packages"
endef

$(eval $(call BuildPackage,rtwpriv))

