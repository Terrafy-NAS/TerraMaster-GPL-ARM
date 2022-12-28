#
# Copyright (C) 2008-2013 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=libmtdev
PKG_VERSION:=1.1.5
PKG_RELEASE:=1

PKG_SOURCE:=mtdev-$(PKG_VERSION).tar.gz
PKG_SOURCE_URL:=http://bitmath.org/code/mtdev/
PKG_BUILD_DIR:=$(BUILD_DIR)/mtdev-$(PKG_VERSION)/
PKG_MD5SUM:=52c9610b6002f71d1642dc1a1cca5ec1 

include $(INCLUDE_DIR)/package.mk

define Package/libmtdev
  SECTION:=xorg-libraries
  CATEGORY:=Xorg
  SUBMENU:=libraries
  TITLE:=mtdev Library
  URL:=http://bitmath.org/code/mtdev/
endef

define Package/mtdev/description
	The mtdev is a stand-alone library which transforms all variants of kernel MT events 
	to the slotted type B protocol. The events put into mtdev may be from any MT device, 
	specifically type A without contact tracking, type A with contact tracking, or type B 
	with contact tracking. See the kernel documentation for further details.
endef

define Package/Configure
	( cd "$(PKG_BUILD_DIR)"; $(TARGET_CONFIGURE_VARS) $./autogen.sh $(TARGET_CONFIGURE_ARGS))
	$(call Build/Configure/Default)
endef

define Build/Compile
	$(MAKE) -C $(PKG_BUILD_DIR)
	$(MAKE) -C $(PKG_BUILD_DIR) DESTDIR=$(PKG_INSTALL_DIR) install
endef

define Package/libmtdev/install
	$(INSTALL_DIR) $(1)/usr/lib
	$(CP) $(PKG_INSTALL_DIR)/usr/lib/libmtdev*.so* $(1)/usr/lib/
endef

define Build/InstallDev
	$(INSTALL_DIR) $(1)/usr/include \
		$(1)/usr/lib/pkgconfig
	$(CP) $(PKG_INSTALL_DIR)/usr/include/*.h $(1)/usr/include
	$(CP) $(PKG_INSTALL_DIR)/usr/lib/libmtdev*.so* $(1)/usr/lib
	$(CP) $(PKG_INSTALL_DIR)/usr/lib/pkgconfig/* $(1)/usr/lib/pkgconfig/
endef

$(eval $(call BuildPackage,libmtdev))
