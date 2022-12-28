#
# Copyright (C) 2016 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=rtnicpg
#PKG_VERSION:=2017
PKG_RELEASE:=1

PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_NAME)

include $(INCLUDE_DIR)/package.mk
define Package/rtnicpg
  SECTION:=utils
  CATEGORY:=Utilities
  SUBMENU:=Network Devices
  TITLE:=PG tool for Realtek Ethernet Controller
  DEPENDS:=+electric-fence
endef
define Package/rtnicpg/description
  PG tool for Realtek Ethernet Controller
endef
define Build/Prepare
endef

define Build/Compile
endef

define Build/InstallDev

endef

define Package/rtnicpg/install
	$(SCRIPT_DIR)/ipkg-extract $(PKG_NAME) "$(1)" "$(TOPDIR)/packages"
endef

$(eval $(call BuildPackage,rtnicpg))

