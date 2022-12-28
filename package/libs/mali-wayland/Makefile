#
# Copyright (C) 2016 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=mali-wayland
#PKG_VERSION:=2017
PKG_RELEASE:=1

PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_NAME)

PKG_BUILD_DEPENDS:=libdrm libwayland
include $(INCLUDE_DIR)/package.mk
define Package/mali-wayland
  SECTION:=xorg-framework
  CATEGORY:=Xorg
  SUBMENU:=Mali
  TITLE:=Mali Libraries with Wayland Support
  DEPENDS:=+libdrm +kmod-lib-mali +libwayland 
  DEPENDS+= +kmod-mali-wayland
endef

define Package/mali-wayland/config
  source "$(SOURCE)/Config.in"
endef

ifeq ($(CONFIG_MALI_OPENGLES_FBDEV),y)
IPK_NAME=mali-fbdev
else ifeq ($(CONFIG_MALI_OPENGLES_WAYLAND),y)
IPK_NAME=mali-wayland
endif

define Package/mali-wayland/description
  Wayland is intended as a simpler replacement for X, easier to develop and maintain.
  This package contains wayland libraries.
endef
define Build/Prepare
endef

define Build/Compile
endef

define Build/InstallDev
	$(SCRIPT_DIR)/ipkg-extract $(IPK_NAME) "$(1)" $(TOPDIR)/packages
endef

define Package/mali-wayland/install
	$(SCRIPT_DIR)/ipkg-extract $(IPK_NAME) "$(1)" "$(TOPDIR)/packages"
endef

$(eval $(call BuildPackage,mali-wayland))

