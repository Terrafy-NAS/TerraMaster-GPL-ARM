# 
# Copyright (C) 2006-2013 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#
include $(TOPDIR)/rules.mk

PKG_NAME:=findutils
PKG_VERSION:=4.4.2
PKG_RELEASE:=1

PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION).tar.gz
PKG_SOURCE_URL:=@GNU/$(PKG_NAME)
PKG_MD5SUM:=351cc4adb07d54877fa15f75fb77d39f
PKG_CAT:=zcat

PKG_BUILD_PARALLEL:=1

include $(INCLUDE_DIR)/package.mk

define Package/findutils
	SECTION:=utils
	CATEGORY:=Utilities
	DEFAULT:=y
	TITLE:=GNU find utils
	URL:=http://www.gnu.org/software/findutils/
endef

define Package/findutils/description
	The GNU Find Utilities are the basic directory searching utilities of the GNU operating system
endef

CONFIGURE_VARS += \
	gl_cv_func_wcwidth_works=yes \
	gl_cv_header_working_fcntl_h=yes \
	ac_cv_func_fnmatch_gnu=yes 


define Package/findutils/install
	$(INSTALL_DIR) $(1)/usr/bin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/find/find $(1)/usr/bin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/xargs/xargs $(1)/usr/bin
endef

$(eval $(call BuildPackage,findutils))

