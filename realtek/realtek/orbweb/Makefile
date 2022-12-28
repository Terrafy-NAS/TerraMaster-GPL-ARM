#
# Copyright (C) 2015-2016 Realtek
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=orbweb
PKG_RELEASE:=1

include $(INCLUDE_DIR)/package.mk

PKG_BUILD_DIR := $(BUILD_DIR)/$(PKG_NAME)

define Package/orbweb
  SECTION:=net
  CATEGORY:=Network
  TITLE:=OrbWeb M2M Module
  DEPENDS:=+libpthread +librt
endef

define Package/orbweb/description
 OrbWeb M2M Module
endef

define Build/Prepare
endef

define Build/Compile
endef

define Package/orbweb/install
	$(INSTALL_DIR) $(1)/usr/local/sbin/
ifeq ($(CONFIG_TARGET_rtl8117),y)
	$(INSTALL_BIN) ./files/orbwebm2m_realtek_mipsel $(1)/usr/local/sbin/orbwebm2m
endif
ifeq ($(CONFIG_TARGET_rtd1195),y)
	$(INSTALL_BIN) ./files/orbwebm2m_realtek_arm $(1)/usr/local/sbin/orbwebm2m
endif
ifeq ($(CONFIG_TARGET_rtd1295),y)
	$(INSTALL_BIN) ./files/orbwebm2m_realtek_aarch $(1)/usr/local/sbin/orbwebm2m
endif
endef

$(eval $(call BuildPackage,orbweb))
