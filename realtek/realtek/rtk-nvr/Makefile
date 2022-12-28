
# Copyright (C) 2017 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=rtk-nvr
PKG_RELEASE:=1

include $(INCLUDE_DIR)/package.mk

define Package/rtk-nvr
  SECTION:=nas
  CATEGORY:=Realtek
  TITLE:=Realtek NVR
#  SUBMENU:=NVR
  DEPENDS:=@TARGET_rtd1295 \
	 +gstreamer1-libs-rtk +gstreamer1-rtk \
	 +gstreamer1-utils-rtk \
	 +gstreamer1-plugins-base-rtk \
	 +libgst1app-rtk +libgst1audio-rtk +libgst1pbutils-rtk +libgst1riff-rtk +libgst1rtp-rtk \
	 +libgst1rtsp-rtk +libgst1sdp-rtk +libgst1tag-rtk +libgst1video-rtk \
	 +gst1-mod-alsa-rtk +gst1-mod-app-rtk +gst1-mod-audioconvert-rtk +gst1-mod-audioresample-rtk +gst1-mod-playback-rtk \
	 +gst1-mod-ogg-rtk +gst1-mod-tcp-rtk +gst1-mod-typefindfunctions-rtk +gst1-mod-videoconvert-rtk +gst1-mod-videoscale-rtk +gst1-mod-volume-rtk \
	 +gstreamer1-plugins-good-rtk \
	 +gst1-mod-audioparsers-rtk +gst1-mod-debug-rtk +gst1-mod-isomp4-rtk +gst1-mod-jpeg-rtk +gst1-mod-rtpmanager-rtk \
	 +gst1-mod-rtp-rtk +gst1-mod-rtsp-rtk +gst1-mod-udp-rtk \
	 +gstreamer1-plugins-bad-rtk \
	 +gst1-mod-adaptivedemux-rtk +gst1-mod-uridownloader-rtk +gst1-mod-codecparsers-rtk +gst1-mod-mpegts-rtk \
	 +gst1-mod-faad-rtk +gst1-mod-fragmented-rtk +gst1-mod-jpegformat-rtk +gst1-mod-mpegtsdemux-rtk +gst1-mod-mpegtsmux-rtk \
	 +gst1-mod-rtpbad-rtk +gst1-mod-videoparsersbad-rtk +gst1-mod-vfbdevsink-rtk \
	 +gstreamer1-plugins-rtk +gst1-rtk \
	 +gst1-omx-1-2 \
	 +rtk-supplicant +supportlibs +rtkMediaLib\
	 +kmod-rtk-nvr
endef
define Package/rtk-nvr/description
 This package activates network video recorder (NVR) feature with the least packages
endef

define Package/rtk-nvr-full
  SECTION:=nas
  CATEGORY:=Realtek
  TITLE:=Realtek NVR FULL
#  SUBMENU:=NVR
  DEPENDS:=@TARGET_rtd1295 \
	 +gstreamer1-libs-rtk +gstreamer1-rtk \
	 +gstreamer1-utils-rtk \
	 +gstreamer1-plugins-base-rtk +gst1-plugins-base-rtk \
	 +gstreamer1-plugins-good-rtk +gst1-plugins-good-rtk \
	 +gstreamer1-plugins-bad-rtk +gst1-plugins-bad-rtk \
	 +gstreamer1-plugins-ugly-rtk +gst1-plugins-ugly-rtk \
	 +gstreamer1-plugins-rtk +gst1-rtk \
	 +gst1-omx-1-2 \
	 +gst1-libav \
	 +rtk-supplicant +supportlibs \
	 +kmod-rtk-nvr \
	 +mali-egl +mali-wayland \
	 rtk-nvr
endef
define Package/rtk-nvr-full/description
 This package activates network video recorder (NVR) feature with full-featured NVR shared libraries (gstreamer, mali)
endef

define Package/rtk-qt5-eglfs
  SECTION:=nas
  CATEGORY:=Realtek
  TITLE:=Support QT EGLFS
#  SUBMENU:=NVR
  DEPENDS:=@TARGET_rtd1295 \
	  rtk-nvr \
      +qt5-eglfs
endef
define Package/rtk-qt5-eglfs/description
 This package activates qt5 eglfs feature
endef


define Package/rtk-qt5-wayland
  SECTION:=nas
  CATEGORY:=Realtek
  TITLE:=Support QT Weston
#  SUBMENU:=NVR
  DEPENDS:=@TARGET_rtd1295 \
	  rtk-nvr \
     +qt5-wayland \
	 +weston 
endef
define Package/rtk-qt5-wayland/description
 This package activates qt5 wayland feature
endef

define Package/rtk-nvr/install
endef


#$(eval $(call BuildPackage,rtk-qt5-eglfs))
$(eval $(call BuildPackage,rtk-qt5-wayland))
$(eval $(call BuildPackage,rtk-nvr))
$(eval $(call BuildPackage,rtk-nvr-full))

