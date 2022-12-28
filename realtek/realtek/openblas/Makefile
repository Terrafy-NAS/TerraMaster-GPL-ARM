
# Copyright (C) 2008-2017 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=openblas
PKG_VERSION:=0.2.20
PKG_RELEASE:=1

PKG_SOURCE_PROTO:=git
PKG_SOURCE_URL=https://github.com/xianyi/OpenBLAS.git
PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION).tar.gz
PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_NAME)-$(PKG_VERSION)
PKG_SOURCE_VERSION:=5dde4e65d321076582a2fafe16949d2160551e81
PKG_SOURCE_SUBDIR:=$(PKG_NAME)-$(PKG_VERSION)

include $(INCLUDE_DIR)/package.mk


define Package/openblas
  SECTION:=libs
  CATEGORY:=Libraries
  TITLE:=libopenblas
  URL:=https://www.openblas.net/
  #DEPENDS:=@TARGET_rtd1295 @RTK_OVERRIDE_OVERLAY_FS +libc +zlib +libstdcpp +alsa-lib +libfreetype +zulu
endef

define Package/openblas/description
	OpenBLAS is an optimized BLAS library based on GotoBLAS2 1.13 BSD version
endef

define Build/Compile
	$(MAKE) -C $(PKG_BUILD_DIR) HOSTCC=gcc BINARY=64 TARGET=ARMV8 HOSTCC=gcc CC=$(TARGET_CC_NOCACHE) FC=$(TARGET_FORTRAN) 
	$(MAKE) install PREFIX=$(PKG_INSTALL_DIR) -C $(PKG_BUILD_DIR) 
endef

define Build/InstallDev
	$(INSTALL_DIR)  	$(1)/usr
	$(CP) 		$(PKG_INSTALL_DIR)/* $(1)/usr
endef

define Package/openblas/install
	$(INSTALL_DIR)  	$(1)/usr/lib
	$(CP) 		$(PKG_INSTALL_DIR)/lib/* $(1)/usr/lib
endef

$(eval $(call BuildPackage,openblas))

