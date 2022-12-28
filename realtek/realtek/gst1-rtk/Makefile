#
# Copyright (C) 2016 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=gst1-rtk
#PKG_VERSION:=2017
PKG_RELEASE:=1

PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_NAME)

PKG_BUILD_DEPENDS:= libgstreamer1-rtk gstreamer1-plugins-base-rtk supportlibs rtkMediaLib
include $(INCLUDE_DIR)/package.mk
define Package/gst1-rtk
  TITLE+= plugins collection (rtk)
  DEPENDS+= +openmax +gstreamer1-rtk +libgst1video-rtk +supportlibs +rtkMediaLib
  HIDDEN:=1
endef
define Build/Prepare
endef

define Build/Compile
endef

define Build/InstallDev

endef

define Package/gst1-rtk/install
	$(SCRIPT_DIR)/ipkg-extract $(PKG_NAME) "$(1)" "$(TOPDIR)/packages"
endef

$(eval $(call GstBuildPlugin,vfbdevsink,vfbdev support,video,,+openmax))

$(eval $(call BuildPackage,gst1-rtk))
