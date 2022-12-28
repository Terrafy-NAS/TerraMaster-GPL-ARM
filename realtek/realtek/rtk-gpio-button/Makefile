#
# Copyright (C) 2006-2014 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=rtk-gpio-button
PKG_RELEASE=1

include $(INCLUDE_DIR)/package.mk

define Package/rtk-gpio-button
  SECTION:=nas
  CATEGORY:=Realtek
  TITLE:=Realtek GPIO button function
  DEPENDS:=@TARGET_rtd1295 +kmod-hid +kmod-hid-generic +kmod-input-gpio-keys +triggerhappy
endef

define Package/rtk-gpio-button/config
	source "$(SOURCE)/Config.in"
endef

$(eval $(call BuildPackage,rtk-gpio-button))
