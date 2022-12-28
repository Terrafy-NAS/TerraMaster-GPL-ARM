#
# Copyright (C) 2006-2016 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=gst-rtsp-server
PKG_VERSION:=1.6.4
PKG_RELEASE=1

PKG_BUILD_DIR:=$(BUILD_DIR)/gst-rtsp-server-$(PKG_VERSION)
PKG_SOURCE:=gst-rtsp-server-$(PKG_VERSION).tar.xz
PKG_SOURCE_URL:=http://gstreamer.freedesktop.org/src/gst-rtsp-server/
PKG_MD5SUM:=4734b3c94e9d785cbff884720a8c826f

PKG_FIXUP:=autoreconf
PKG_INSTALL:=1

PKG_BUILD_DEPENDS:= +libgstreamer1-rtk +gst1-plugins-base-rtk
include $(INCLUDE_DIR)/package.mk

define Package/gst-rtsp-server
  CATEGORY:=Multimedia
  SECTION:=multimedia
  TITLE:=GStreamer RTSP Server Library
  DEPENDS:= +libgstreamer1-rtk +gst1-plugins-base-rtk \
	    +libgst1app +libgst1net +libgst1rtp +libgst1rtsp +libgst1sdp
endef

define Package/gst-rtsp-server/description
 gst-rtsp-server is a library on top of GStreamer for building an RTSP server
endef

GST_VERSION:=1.0
define Build/InstallDev
	$(INSTALL_DIR) $(1)/usr/lib
	$(CP) $(PKG_INSTALL_DIR)/usr/lib/libgstrtspserver-1.0.so* $(1)/usr/lib/
	$(INSTALL_DIR) $(1)/usr/lib/pkgconfig
	$(CP) $(PKG_INSTALL_DIR)/usr/lib/pkgconfig/* $(1)/usr/lib/pkgconfig
	$(INSTALL_DIR) $(1)/usr/include
	$(CP) $(PKG_INSTALL_DIR)/usr/include/* $(1)/usr/include

endef
define Package/gst-rtsp-server/install
	$(INSTALL_DIR) $(1)/usr/lib
	$(CP) $(PKG_INSTALL_DIR)/usr/lib/libgstrtspserver-1.0.so* $(1)/usr/lib/
	$(INSTALL_DIR) $(1)/usr/bin/gst-rtsp-server
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/examples/.libs/test-* $(1)/usr/bin/gst-rtsp-server/	
endef

$(eval $(call BuildPackage,gst-rtsp-server))
