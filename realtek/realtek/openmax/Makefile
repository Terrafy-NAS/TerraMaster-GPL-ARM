#
# Copyright (C) 2016 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=openmax
#PKG_VERSION:=2017
PKG_RELEASE:=1

PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_NAME)

include $(INCLUDE_DIR)/package.mk
define Package/openmax
  SECTION:=multimedia
  CATEGORY:=Multimedia
#  SUBMENU:=Multimedia
  TITLE:=Realtek OpenMAX libraries
  DEPENDS:=+libstdcpp +glib2 $(LIBRPC_DEPENDS) +jansson
  DEPENDS+= +kmod-openmax
endef
define Package/openmax/description
 Realtek OpenMAX libraries and various daemons
endef
define Build/Prepare
endef

define Build/Compile
endef

define Build/InstallDev
	$(SCRIPT_DIR)/ipkg-extract $(PKG_NAME) "$(1)" $(TOPDIR)/packages
endef

define Package/openmax/install
	$(SCRIPT_DIR)/ipkg-extract $(PKG_NAME) "$(1)" "$(TOPDIR)/packages"
endef

$(eval $(call BuildPackage,openmax))

