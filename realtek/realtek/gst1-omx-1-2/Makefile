#
# Copyright (C) 2016 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=gst1-omx-1-2
#PKG_VERSION:=2017
PKG_RELEASE:=1

PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_NAME)

PKG_BUILD_DEPENDS:= openmax libgstreamer1-rtk gstreamer1-plugins-base-rtk
include $(INCLUDE_DIR)/package.mk
define Package/gst1-omx-1-2
  #SECTION:=nas
  #CATEGORY:=Realtek NAS
  SECTION:=multimedia
  CATEGORY:=Multimedia
#  SUBMENU:=Multimedia
  TITLE:=GStreamer OpenMAX plugin v$(PKG_VERSION)
  DEPENDS:= +libgstreamer1-rtk \
  			+gstreamer1-plugins-base-rtk \
	    	+openmax \
	    	+libgst1audio-rtk \
  			+libgst1pbutils-rtk \
			+libgst1video-rtk \

endef
define Package/gst1-omx-1-2/description
 GStreamer OpenMAX IL wrapper plugin
 This plugin wraps available OpenMAX IL components and makes
 them available as standard GStreamer elements.
endef
define Build/Prepare
endef

define Build/Compile
endef

define Build/InstallDev

endef

define Package/gst1-omx-1-2/install
	$(SCRIPT_DIR)/ipkg-extract $(PKG_NAME) "$(1)" "$(TOPDIR)/packages"
endef

$(eval $(call BuildPackage,gst1-omx-1-2))

