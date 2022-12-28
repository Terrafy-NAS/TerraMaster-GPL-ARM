#
# Copyright (C) 2016 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=rtk-transcode
PKG_RELEASE:=1

include $(INCLUDE_DIR)/package.mk
define Package/rtk-transcode
 SECTION:=nas
 CATEGORY:=Realtek
 TITLE:=Realtek Transcode
 #SUBMENU:=Transcode
 DEPENDS:=@TARGET_rtd1295 \
	 +openmax \
 	 +mediainfo \
	 +rtk-supplicant 
endef

define Package/rtk-transcode/install
 true
endef

define Package/rtk-transcode/description
 This package activates hardware acceleration transcode feature
endef

define Package/rtk-audio-out
 SECTION:=nas
 CATEGORY:=Realtek
 TITLE:=Enable Audio Output
# SUBMENU:=Transcode
 KCONFIG:=CONFIG_SOUND=y \
	CONFIG_SND=y \
	CONFIG_SND_TIMER=y \
	CONFIG_SND_PCM=y \
	CONFIG_SND_HWDEP=y \
	CONFIG_SND_RAWMIDI=y \
	CONFIG_SND_COMPRESS_OFFLOAD=y \
	CONFIG_SND_JACK=y \
	CONFIG_SND_PCM_TIMER=y \
	CONFIG_SND_HRTIMER=y \
	CONFIG_SND_SUPPORT_OLD_API=y \
	CONFIG_SND_PROC_FS=y \
	CONFIG_SND_VERBOSE_PROCFS=y \
	CONFIG_SND_DRIVERS=y \
	CONFIG_SND_HDA_PREALLOC_SIZE=64 \
	CONFIG_SND_ARM=y \
	CONFIG_SND_ARMAACI=n \
	CONFIG_SND_REALTEK=y \
	CONFIG_SND_USB=y \
	CONFIG_SND_USB_AUDIO=y \
	CONFIG_SND_SOC=y \
	CONFIG_SND_SOC_COMPRESS=y \

 DEPENDS:=@TARGET_rtd1295 \
	rtk-transcode +alsa-lib
endef

define Package/gstreamer-hw-transcode
 SECTION:=nas
 CATEGORY:=Realtek
 TITLE:=Realtek GStreamer Transcode
 #SUBMENU:=Transcode
 DEPENDS:=@TARGET_rtd1295 \
	 +gstreamer1-libs-rtk +gstreamer1-rtk \
	 +gstreamer1-utils-rtk \
	 +gstreamer1-plugins-base-rtk +gst1-plugins-base-rtk \
	 +gstreamer1-plugins-good-rtk +gst1-plugins-good-rtk \
	 +gstreamer1-plugins-bad-rtk +gst1-plugins-bad-rtk \
	 +gstreamer1-plugins-ugly-rtk +gst1-plugins-ugly-rtk \
	 +gstreamer1-plugins-rtk \
	 +gst1-omx-1-2 \
	 +gst1-libav \
	rtk-transcode
endef

define Package/gstreamer-hw-transcode/description
 This package activates transcode feature by gstreamer
endef

define Build/Compile
endef

define Package/gstreamer-hw-transcode/install
# $(INSTALL_DIR) $(1)/usr/bin/
# $(INSTALL_DIR) $(1)/etc
# $(INSTALL_BIN) ./files/transcode.sh $(1)/usr/bin/
# $(INSTALL_DATA) ./files/template.txt $(1)/etc
endef

define Package/ffmpeg-hw-transcode
 SECTION:=nas
 CATEGORY:=Realtek
 TITLE:=Realtek FFMPEG Transcode
 #SUBMENU:=Transcode
 DEPENDS:=@TARGET_rtd1295 \
	+ffmpeg \
	rtk-transcode

endef


define Package/ffmpeg-hw-transcode/description
 This package activates transcode feature by ffmpeg
endef
$(eval $(call BuildPackage,rtk-transcode))
$(eval $(call BuildPackage,rtk-audio-out))
$(eval $(call BuildPackage,gstreamer-hw-transcode))
$(eval $(call BuildPackage,ffmpeg-hw-transcode))

