#
# Copyright (C) 2011-2015 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=gst1-plugins-bad-rtk
PKG_VERSION:=1.6.4
PKG_RELEASE:=1
RELEASE_DATE:=$(shell date +%Y%m%d)

PKG_LICENSE:=LGPLv2 GPLv2
PKG_LICENSE_FILES:=COPYING.LIB COPYING

PKG_SOURCE:=rtkdl-$(PKG_NAME).tar.gz
PKG_BUILD_DIR:=$(BUILD_DIR)/gst-plugins-bad-rtk-$(PKG_VERSION)
PKG_SOURCE_PROTO:=git
PKG_SOURCE_URL:=xxx
PKG_SOURCE_SUBDIR:=gst-plugins-bad-rtk-$(PKG_VERSION)
PKG_SOURCE_VERSION:=7a176a4421b39d37712d65527a8c192dd03d2527
PKG_SOURCE_BRANCH:=1.6.4

PKG_BUILD_DEPENDS:= libgstreamer1-rtk gstreamer1-plugins-base-rtk

PKG_FIXUP:=autoreconf
PKG_INSTALL:=1

include $(INCLUDE_DIR)/package.mk
include $(INCLUDE_DIR)/nls.mk

GST_BAD_LIBS:=
GST_BAD_MODULES:=

define Package/gstreamer1-bad/Default
  #SECTION:=multimedia
  #CATEGORY:=Realtek NAS
  #SUBMENU:=Multimedia
  SECTION:=multimedia
  CATEGORY:=Multimedia
  TITLE:=GStreamer
  URL:=http://gstreamer.freedesktop.org/
  DEPENDS:= +libgstreamer1-rtk $(ICONV_DEPENDS)
endef

define Package/gstreamer1-bad/description/Default
 GStreamer open source multimedia framework
endef


define Package/gst1-plugins-bad-rtk
$(call Package/gstreamer1-bad/Default)
  TITLE+= plugins collection (bad)
  DEPENDS+= $(GST_DEPENDS)
  HIDDEN:=1
endef

define Package/gts1-plugins-bad-rtk/description
$(call Package/gstreamer1-bad/description/Default)
 .
 This meta package contains only dependencies to the other plugins from
 the bad plugins collection.
endef

define Package/gstreamer1-plugins-bad-rtk
  $(call Package/gstreamer1-bad/Default)
  TITLE+= plugins collection (bad)
  DEPENDS:=+ALL:gst1-plugins-bad-rtk +gstreamer1-plugins-base-rtk +openmax
endef

define Package/gstreamer1-plugins-bad-rtk/config
    menu "Select GStreamer bad modules and libraries"
      depends on PACKAGE_gstreamer1-plugins-bad-rtk


    config gst1-plugins-bad-rtk-all
      bool "Include all GStreamer bad plugins"
      select PACKAGE_gst1-plugins-bad-rtk

    comment "Modules"

   $(foreach mod,$(GST_BAD_MODULES), \
    config PACKAGE_gst1-mod-$(mod)-rtk
      prompt "GStreamer $(mod) module"

   )

    comment "Libraries"

   $(foreach lib,$(GST_BAD_LIBS), \
    config PACKAGE_libgst1$(lib)-rtk
      prompt "GStreamer $(lib) library"

   )

  endmenu

endef

GST_VERSION:=1.0

CONFIGURE_ARGS += \
	--disable-debug \
	--disable-examples \
	--disable-nls	\
	\
	--disable-directsound \
	--disable-directdraw \
	--disable-osx_video \
	--disable-quicktime \
	--disable-vcd \
	--disable-assrender \
	--disable-apexsink \
	--disable-bz2 \
	--disable-dc1394 \
	--disable-directfb \
	--disable-dts \
	--disable-resindvd \
	--disable-flite \
	--disable-gsm \
	--disable-kate \
	--disable-ladspa \
	--disable-lv2 \
	--disable-modplug \
	--disable-mimic \
	--disable-libmms \
	--disable-mpeg2enc \
	--disable-mplex \
	--disable-musepack \
	--disable-mythtv \
	--disable-nas \
	--disable-neon \
	--disable-ofa \
	--disable-rsvg \
	--disable-timidity \
	--disable-wildmidi \
	--disable-sdl \
	--disable-sdltest \
	--disable-sndfile \
	--disable-soundtouch \
	--disable-spc \
	--disable-gme \
	--disable-xvid \
	--disable-dvb \
	--disable-wininet \
	--disable-acm \
	--disable-vdpau \
	--disable-schro \
	--disable-zbar \
	--disable-srtp \
	\
	--without-libiconv-prefix \
	--without-libintl-prefix \
	--with-libgcrypt-prefix="$(STAGING_DIR)/usr" \
	--without-x \

TARGET_CFLAGS+= -std=gnu99

EXTRA_LDFLAGS+= \
	-Wl,-rpath-link=$(STAGING_DIR)/usr/lib \
	$(if $(ICONV_FULL),-liconv) \

define Build/Prepare
	tar -C $(PKG_BUILD_DIR)/.. -xzf $(DL_DIR)/$(PKG_SOURCE)
	(cd $(PKG_BUILD_DIR) && mv gst-plugins-bad/* . && rm -rf gst-plugins-base gst-plugins-good gst-plugins-ugly gst-plugins-bad gst-rtk)
	$(Build/Patch)
endef

define Package/gst1-plugins-bad-rtk/install
	/bin/true
endef

# 1: short name
# 2: description
# 3: dependencies on other gstreamer libraries (short name)
# 4: dependencies on other packages
define GstBuildLibrary

  GST_DEPENDS += +libgst1$(1)-rtk

  GST_BAD_LIBS+= $(1)
  define Package/libgst1$(1)-rtk
    $(call Package/gstreamer1-bad/Default)
    TITLE+= $(2) library (base)
    DEPENDS+= $$(foreach p,$(3),+libgst1$$(p)-rtk) $(4)
    HIDDEN:=1
  endef

  define Package/libgst1$(1)-rtk/description
   $(call Package/gstreamer1-bad/description/Default)
   .
   This package contains the GStreamer $(2) library.
  endef

  define Package/libgst1$(1)-rtk/install
	$(INSTALL_DIR) $$(1)/usr/lib
	( cd $(PKG_INSTALL_DIR); $(CP) \
		./usr/lib/libgst$(1)-$(GST_VERSION).so.* \
		$$(1)/usr/lib/ \
	)
  endef

  $$(eval $$(call BuildPackage,libgst1$(1)-rtk))
endef

$(eval $(call GstBuildLibrary,adaptivedemux,adaptivedemux,app uridownloader,))
$(eval $(call GstBuildLibrary,photography,photography,,))
$(eval $(call GstBuildLibrary,basecamerabinsrc,basecamerabinsrc,app,))
$(eval $(call GstBuildLibrary,uridownloader,uridownloader,,))
$(eval $(call GstBuildLibrary,codecparsers,codecparsers,,))
$(eval $(call GstBuildLibrary,mpegts,mpegts,,))

# 1: short name
# 2: description
# 3: dependencies on other gstreamer libraries (short name)
# 4: dependencies on other gstreamer plugins (short name)
# 5: dependencies on other packages
define GstBuildPlugin

  GST_DEPENDS += +gst1-mod-$(1)-rtk

  GST_BAD_MODULES+= $(1)

  define Package/gst1-mod-$(1)-rtk
    $(call Package/gstreamer1-bad/Default)
    TITLE+= $(2) plugin (bad)
    DEPENDS+= $$(foreach p,$(3),+libgst1$$(p)-rtk) $$(foreach p,$(4),+gst1-mod-$$(p)-rtk) $(5)
    HIDDEN:=1
  endef

  define Package/gst1-mod-$(1)-rtk/description
   $(call Package/gstreamer1-bad/description/Default)
   .
   This package contains the GStreamer $(2) plugin.
  endef

  define Package/gst1-mod-$(1)-rtk/install
	$(INSTALL_DIR) $$(1)/usr/lib/gstreamer-$(GST_VERSION)
	( cd $(PKG_INSTALL_DIR); $(CP) \
		./usr/lib/gstreamer-$(GST_VERSION)/libgst$(1).so* \
		$$(1)/usr/lib/gstreamer-$(GST_VERSION)/ \
	)
  endef

  $$(eval $$(call BuildPackage,gst1-mod-$(1)-rtk))
endef

$(eval $(call GstBuildPlugin,adpcmdec,adpcm decoding support,audio,,))
$(eval $(call GstBuildPlugin,adpcmenc,adpcm encoding support,audio,,))
$(eval $(call GstBuildPlugin,aiff,aiff support,audio tag,,))
$(eval $(call GstBuildPlugin,asfmux,asf muxing support,rtp,,))
$(eval $(call GstBuildPlugin,autoconvert,autoconvert support,,,))
$(eval $(call GstBuildPlugin,bayer,bayer support,video,,))
$(eval $(call GstBuildPlugin,camerabin2,camerabin support,basecamerabinsrc photography tag pbutils app,,))
$(eval $(call GstBuildPlugin,dataurisrc,dataurisrc support,,,))
$(eval $(call GstBuildPlugin,debugutilsbad,debugutils support,video,,))
$(eval $(call GstBuildPlugin,dvdspu,dvdspu support,video,,))
$(eval $(call GstBuildPlugin,faac,faac support,audio pbutils,,+libfaac))
$(eval $(call GstBuildPlugin,faad,faad support,audio,,+libfaad2))
$(eval $(call GstBuildPlugin,fdkaac,fdkaac support,audio pbutils,,+fdk-aac))
$(eval $(call GstBuildPlugin,fbdevsink,fbdev support,video,,))
$(eval $(call GstBuildPlugin,festival,festival support,audio,,))
$(eval $(call GstBuildPlugin,fragmented,fragmented support,pbutils adaptivedemux,,+libnettle))
$(eval $(call GstBuildPlugin,frei0r,frei0r support,controller video,,))
$(eval $(call GstBuildPlugin,id3tag,id3tag support,tag,,))
$(eval $(call GstBuildPlugin,jpegformat,jpegformat support,tag,,))
$(eval $(call GstBuildPlugin,liveadder,liveadder support,audio,,))
$(eval $(call GstBuildPlugin,mpegpsdemux,mpegpsdemux support,pbutils tag,,))
$(eval $(call GstBuildPlugin,mpegpsmux,mpegpsmux support,,,))
$(eval $(call GstBuildPlugin,mpegtsdemux,mpegtsdemux support,codecparsers mpegts pbutils tag,,))
$(eval $(call GstBuildPlugin,mpegtsmux,mpegtsmux support,video mpegts tag,,))
$(eval $(call GstBuildPlugin,mxf,mxf support,audio video,,))
$(eval $(call GstBuildPlugin,opus,OPUS plugin library,audio tag rtp,,+libopus))
$(eval $(call GstBuildPlugin,pcapparse,pcapparse support,,,))
$(eval $(call GstBuildPlugin,pnm,pnm support,video,,))
$(eval $(call GstBuildPlugin,rawparse,rawparse support,audio video,,))
$(eval $(call GstBuildPlugin,rfbsrc,librfb support,video,,))
$(eval $(call GstBuildPlugin,rtpbad,RTP,audio codecparsers rtp tag pbutils video,,))
$(eval $(call GstBuildPlugin,sdpelem,sdp support,rtp sdp,,))
$(eval $(call GstBuildPlugin,segmentclip,segmentclip support,audio,,))
$(eval $(call GstBuildPlugin,shm,POSIX shared memory source and sink,,,+librt))
$(eval $(call GstBuildPlugin,siren,siren support,audio rtp,,))
$(eval $(call GstBuildPlugin,speed,speed support,audio,,))
$(eval $(call GstBuildPlugin,subenc,subenc support,controller,,))
#$(eval $(call GstBuildPlugin,srtp,srtp support,rtp,,+libsrtp))
$(eval $(call GstBuildPlugin,videoparsersbad,videoparse support,codecparsers pbutils video,,))

$(eval $(call BuildPackage,gstreamer1-plugins-bad-rtk))
$(eval $(call BuildPackage,gst1-plugins-bad-rtk))
