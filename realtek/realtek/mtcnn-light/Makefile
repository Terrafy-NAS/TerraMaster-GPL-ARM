#
# Copyright (C) 2017 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=mtcnn-light
PKG_VERSION:=0.7.97
PKG_RELEASE:=1

PKG_SOURCE_PROTO:=git
PKG_SOURCE_URL:=https://github.com/AlphaQi/MTCNN-light.git
PKG_SOURCE_SUBDIR:=$(PKG_NAME)-$(PKG_VERSION)
PKG_SOURCE_VERSION:=ca62865010917085ec9d7c56c0b3ef13d0cf87c3
PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION).tar.bz2

include $(INCLUDE_DIR)/package.mk
include $(INCLUDE_DIR)/cmake.mk

define Package/mtcnn-light
  SECTION:=utilities
  CATEGORY:=Multimedia
  TITLE:=MTCNN-Light
  DEPENDS:=+opencv +openblas
endef


define Package/mtcnn-light/description
  MTCNN Demo Code
endef

define Build/Install
	echo "Do not thing"
	true
endef

define Package/mtcnn-light/install
	$(INSTALL_DIR) $(1)/root
	$(CP) $(PKG_BUILD_DIR)/main $(1)/root
	$(CP) $(PKG_BUILD_DIR)/4.jpg $(1)/root
	$(CP) $(PKG_BUILD_DIR)/Pnet.txt $(1)/root
	$(CP) $(PKG_BUILD_DIR)/Rnet.txt $(1)/root
	$(CP) $(PKG_BUILD_DIR)/Onet.txt $(1)/root
endef

$(eval $(call BuildPackage,mtcnn-light))
