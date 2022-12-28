#
# Copyright (C) 2016 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=rtk-reg
#PKG_VERSION:=2017
PKG_RELEASE:=1

PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_NAME)

include $(INCLUDE_DIR)/package.mk
define Package/rtk-reg
  SECTION:=utils
  CATEGORY:=Utilities
  SUBMENU:=CPU tools
  TITLE:=Register R/W tool for Realtek SoC
  KCONFIG:= \
	CONFIG_UIO=y \
	CONFIG_UIO_ASSIGN_MINOR=y \
	CONFIG_UIO_RTK_RBUS=y \
	CONFIG_UIO_RTK_REFCLK=n \
	CONFIG_UIO_RTK_SE=n \
	CONFIG_UIO_RTK_MD=n
  DEPENDS:=@TARGET_rtd1295 +libstdcpp +kmod-rtk_uio
endef
define Package/rtk-reg/description
 Realtek SoC Register R/W tool
endef
define Build/Prepare
endef

define Build/Compile
endef

define Build/InstallDev

endef

define Package/rtk-reg/install
	$(SCRIPT_DIR)/ipkg-extract $(PKG_NAME) "$(1)" "$(TOPDIR)/packages"
endef

$(eval $(call BuildPackage,rtk-reg))

