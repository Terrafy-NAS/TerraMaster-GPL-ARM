#
# Copyright (C) 2007 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=traceroute
PKG_VERSION:=2.0.21
PKG_RELEASE:=1

PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION).tar.gz
PKG_SOURCE_URL:=http://downloads.sourceforge.net/traceroute/
PKG_MD5SUM:=79289adabd6f3ebf9160fc0815ab3150

include $(INCLUDE_DIR)/package.mk

define Package/traceroute
  SECTION:=net
  CATEGORY:=Network
  TITLE:=Traceroute for Linux
  DEPENDS=
  URL:=http://sourceforge.net/projects/traceroute/
endef

define Package/traceroute/description
    Traceroute for Linux
    http://sourceforge.net/projects/traceroute/
endef


define Package/traceroute/install
	$(INSTALL_DIR) $(1)/usr/bin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/traceroute/traceroute $(1)/usr/bin
endef

$(eval $(call BuildPackage,traceroute))

