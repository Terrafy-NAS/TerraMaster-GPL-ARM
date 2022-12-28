#
# Copyright (C) 2017 Daniel Engberg <daniel.engberg.lists@pyret.net>
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=fdk-aac
PKG_VERSION:=0.1.5
PKG_RELEASE:=1
PKG_MAINTAINER:=Daniel Engberg <daniel.engberg.lists@pyret.net>
PKG_LICENSE:=Fraunhofer-FDK-AAC-for-Android
PKG_LICENSE_FILES:=NOTICE

PKG_SOURCE_PROTO:=git
PKG_SOURCE_URL=https://github.com/mstorsjo/fdk-aac/
PKG_SOURCE_SUBDIR=$(PKG_NAME)-$(PKG_VERSION)
PKG_SOURCE_VERSION:=74c1a2a4f831285cbd93ec1427f1670d3c5c5e52
PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION).tar.xz
PKG_MIRROR_HASH:=d2ff3ca03842e96f3f18619f8a27ea03fb5d1e2266e4010cbb4803bf6e1fe62b

PKG_FIXUP:=autoreconf
PKG_INSTALL:=1

include $(INCLUDE_DIR)/package.mk

define Package/fdk-aac
  SECTION:=libs
  CATEGORY:=Libraries
  DEPENDS:=@BUILD_PATENTED
  TITLE:=Fraunhofer FDK AAC Codec Library
  URL:=https://sourceforge.net/projects/opencore-amr/
endef

define Package/fdk-aac/description
  Port of the Fraunhofer FDK AAC Codec Library for Android
endef

define Package/fdk-aac/install	
	$(INSTALL_DIR) $(1)/usr/lib/
	$(CP) $(PKG_INSTALL_DIR)/usr/lib/libfdk-aac.so* $(1)/usr/lib/
endef

TARGET_CFLAGS += $(FPIC)

define Build/InstallDev
	$(INSTALL_DIR) $(1)/usr/include/
	$(CP) \
		$(PKG_INSTALL_DIR)/usr/include/fdk-aac \
		$(1)/usr/include/
	$(INSTALL_DIR) $(1)/usr/lib/pkgconfig
	$(CP) \
		$(PKG_INSTALL_DIR)/usr/lib/libfdk-aac.{a,so*,la} \
		$(1)/usr/lib/
	$(INSTALL_DATA) \
		$(PKG_INSTALL_DIR)/usr/lib/pkgconfig/* \
		$(1)/usr/lib/pkgconfig/
endef

$(eval $(call BuildPackage,fdk-aac))
