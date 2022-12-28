#
# Copyright (C) 2016 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=rtk-onvif
PKG_RELEASE:=1

include $(INCLUDE_DIR)/package.mk

define Package/rtk-onvif
  SECTION:=nas
  CATEGORY:=Realtek
  SUBMENU:=Developing
  TITLE:=Realtek NAS ONVIF
  DEPENDS:=@TARGET_rtd1295 \
	+openrtsp \
	+python-netifaces
endef

define Package/rtk-onvif/description
 This package activates ONVIF feature with simple NVR prototype system
endef

define Build/Compile    
        true
endef 

define Package/rtk-onvif/install
	$(INSTALL_DIR) $(1)/etc
	$(CP) ./files/etc/* $(1)/etc/
	$(INSTALL_DIR) $(1)/usr/local/bin
	$(CP) ./files/nvr $(1)/usr/local/bin
	ln -s /mnt/sda1/recording $(1)/usr/local/bin/nvr/recording
endef

$(eval $(call BuildPackage,rtk-onvif))
