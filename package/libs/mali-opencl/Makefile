#
# Copyright (C) 2016 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=mali-opencl
#PKG_VERSION:=2017
PKG_RELEASE:=1

PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_NAME)

include $(INCLUDE_DIR)/package.mk
define Package/mali-opencl
  SECTION:=libs
  CATEGORY:=Libraries
  SUBMENU:=Mali
  TITLE:=Mali OpenCL Library
  DEPENDS:=+kmod-lib-mali +libstdcpp
endef
define Package/mali-opencl/description
  OpenCL is for generic computing on heterogeneous multiprocessors, including GPU.
  This package contains OpenCL library.
endef
define Build/Prepare
endef

define Build/Compile
endef

define Build/InstallDev
	$(SCRIPT_DIR)/ipkg-extract $(PKG_NAME) "$(1)" $(TOPDIR)/packages
endef

define Package/mali-opencl/install
	$(SCRIPT_DIR)/ipkg-extract $(PKG_NAME) "$(1)" "$(TOPDIR)/packages"
endef

$(eval $(call BuildPackage,mali-opencl))

