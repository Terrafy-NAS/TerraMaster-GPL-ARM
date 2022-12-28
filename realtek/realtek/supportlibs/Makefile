#
# Copyright (C) 2016 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=supportlibs
#PKG_VERSION:=2017
PKG_RELEASE:=1

PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_NAME)

include $(INCLUDE_DIR)/package.mk
define Package/supportlibs
  SECTION:=nas
#  CATEGORY:=Realtek
  TITLE:=Realtek NVR support library
#  SUBMENU:=NVR
  DEPENDS:=@TARGET_rtd1295 +libgstreamer1-rtk +gst1-plugins-base-rtk
endef
define Package/supportlibs/description
 This package provides support libraries for network video recorder (NVR) feature
endef
define Build/Prepare
endef

define Build/Compile
endef

define Build/InstallDev
	$(SCRIPT_DIR)/ipkg-extract $(PKG_NAME) "$(1)" $(TOPDIR)/packages
endef

define Package/supportlibs/install
	$(SCRIPT_DIR)/ipkg-extract $(PKG_NAME) "$(1)" "$(TOPDIR)/packages"
endef

$(eval $(call BuildPackage,supportlibs))

