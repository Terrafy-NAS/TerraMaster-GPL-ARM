#
# Copyright (C) 2017 by Realtek
#

include $(TOPDIR)/rules.mk

PKG_NAME:=rtk-apiapp
PKG_VERSION:=0.9.2
PKG_RELEASE:=1
PKG_MAINTAINER:=E-Cheng Cheng <eccheng@realtek.com>
PKG_LICENSE:=Copyright by Realtek


include $(INCLUDE_DIR)/package.mk

define Package/rtk-apiapp
  SECTION:=nas
  CATEGORY:=Realtek
  SUBMENU:=Developing
  TITLE:=Realtek NAS API for APP (RTL8117)
  DEPENDS:=@TARGET_rtl8117 \
	+luci \
	+luci-base \
	+luci-lib-nixio \
	+luafilesystem
endef

define Package/rtk-apiapp/description
 This package activates API for App feature on RTL8117
endef

define Build/Compile    
        true
endef 

define Package/rtk-apiapp/install
	$(INSTALL_DIR) $(1)/usr/lib/lua
	$(CP) ./files/lua/* $(1)/usr/lib/lua
endef

$(eval $(call BuildPackage,rtk-apiapp))
