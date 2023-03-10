#
# Copyright (C) 2006-2015 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=gst1-libav
PKG_VERSION:=1.6.4
PKG_RELEASE:=1

PKG_MAINTAINER:=W. Michael Petullo <mike@flyn.org>

PKG_SOURCE:=gst-libav-$(PKG_VERSION).tar.xz
PKG_SOURCE_URL:=http://gstreamer.freedesktop.org/src/gst-libav
PKG_MD5SUM:=d9922f6246f4ff0472d0ac3ada287f52

PKG_LICENSE:=GPL-2.0 LGPL-2.0
PKG_LICENSE_FILES:=COPYING COPYING.LIB

PKG_BUILD_DIR:=$(BUILD_DIR)/gst-libav-$(PKG_VERSION)

PKG_FIXUP:=autoreconf
PKG_INSTALL:=1

PKG_USE_MIPS16:=0

GST_VERSION:=1.0

LIBAV_ENCODERS:= \
	ac3 \
	jpegls \
	mpeg1video \
	mpeg2video \
	mpeg4 \
	pcm_s16be \
	pcm_s16le \
	png \
	vorbis \
	wmav1 \
	wmav2 \
	zlib \

LIBAV_DECODERS:= \
	aac \
	ac3 \
	adpcm_g726 \
	atrac3 \
	cook \
	gif \
	h264 \
	jpegls \
	mp2 \
	mp3 \
	mpeg1video \
	mpeg2video \
	mpeg4 \
	mpeg4aac \
	mpegvideo \
	pcm_s16be \
	pcm_s16le \
	png \
	ra_144 \
	ra_288 \
	ralf \
	sipr \
	vorbis \
	wmalossless \
	wmapro \
	wmav1 \
	wmav2 \
	wmavoice \
	zlib \

LIBAV_MUXERS:= \
	ac3 \
	ffm \
	h264 \
	mp3 \
	mp4 \
	mpeg1video \
	mpeg2video \
	mpegts \
	ogg \
	oss \
	rtp \

LIBAV_DEMUXERS:= \
	ac3 \
	ffm \
	h264 \
	mp3 \
	mpegps \
	mpegts \
	mpegvideo \
	ogg \
	rm \
	rtsp \
	sdp \
	v4l2 \

LIBAV_PARSERS:= \
	aac \
	ac3 \
	cook \
	h264 \
	mpegaudio \
	mpegvideo \
	mpeg4video \

LIBAV_PROTOCOLS:= \
	file http pipe rtp tcp udp

PKG_CONFIG_DEPENDS:= \
	$(patsubst %,CONFIG_GST1_LIBAV_ENCODER_%,$(LIBAV_ENCODERS)) \
	$(patsubst %,CONFIG_GST1_LIBAV_DECODER_%,$(LIBAV_DECODERS)) \
	$(patsubst %,CONFIG_GST1_LIBAV_MUXER_%,$(LIBAV_DEMUXERS)) \
	$(patsubst %,CONFIG_GST1_LIBAV_DEMUXER_%,$(LIBAV_DEMUXERS)) \
	$(patsubst %,CONFIG_GST1_LIBAV_PARSER_%,$(LIBAV_PARSERS)) \
	$(patsubst %,CONFIG_GST1_LIBAV_PROTOCOL_%,$(LIBAV_PROTOCOLS))

PKG_BUILD_DEPENDS:= libgstreamer1-rtk gst1-plugins-base-rtk
include $(INCLUDE_DIR)/package.mk
include $(INCLUDE_DIR)/nls.mk

define Package/gst1-libav
  SECTION:=multimedia
  CATEGORY:=Multimedia
  TITLE:=GStreamer Libav plugin
  URL:=http://www.gstreamer.net/modules/gst-libav.html
  DEPENDS:= +libgstreamer1-rtk +gstreamer1-plugins-base-rtk \
	    +gst1-mod-alsa-rtk +libgst1audio-rtk +libgst1pbutils-rtk +libgst1video-rtk \
	    +libbz2 +liblzma
endef

define Package/gst1-libav/description
  GStreamer with libav bindings using internal Libav
endef

define Package/gst1-libav/config
  source "$(SOURCE)/Config.in"
endef

FILTER_CONFIG= \
	$(foreach c, $(3), \
		$(if $(CONFIG_GST1_LIBAV_$(1)_$(c)),--enable-$(2)='$(c)') \
	)

LIBAV_CONFIGURE_ENCODERS:=$(call FILTER_CONFIG,ENCODER,encoder,$(LIBAV_ENCODERS))
LIBAV_CONFIGURE_DECODERS:=$(call FILTER_CONFIG,DECODER,decoder,$(LIBAV_DECODERS))
LIBAV_CONFIGURE_MUXERS:=$(call FILTER_CONFIG,MUXER,muxer,$(LIBAV_MUXERS))
LIBAV_CONFIGURE_DEMUXERS:=$(call FILTER_CONFIG,DEMUXER,demuxer,$(LIBAV_DEMUXERS))
LIBAV_CONFIGURE_PARSERS:=$(call FILTER_CONFIG,PARSER,parser,$(LIBAV_PARSERS))
LIBAV_CONFIGURE_PROTOCOLS:=$(call FILTER_CONFIG,PROTOCOL,protocol,$(LIBAV_PROTOCOLS))

CONFIGURE_ARGS += \
	--without-system-libav \
	--with-libav-extra-configure="--target-os=linux \
	--disable-bsfs \
	--disable-programs \
	--disable-devices \
	--disable-encoders \
	$(LIBAV_CONFIGURE_ENCODERS) \
	--disable-decoders \
	$(LIBAV_CONFIGURE_DECODERS) \
	--disable-muxers \
	$(LIBAV_CONFIGURE_MUXERS) \
	--disable-demuxers \
	$(LIBAV_CONFIGURE_DEMUXERS) \
	--disable-parsers \
	$(LIBAV_CONFIGURE_PARSERS) \
	--disable-protocols \
	$(LIBAV_CONFIGURE_PROTOCOLS) \
	--disable-asm \
	--disable-altivec \
	--disable-amd3dnow \
	--disable-amd3dnowext \
	--disable-mmx \
	--disable-mmxext \
	--disable-sse \
	--disable-sse2 \
	--disable-sse3 \
	--disable-ssse3 \
	--disable-sse4 \
	--disable-sse42 \
	--disable-avx \
	--disable-xop \
	--disable-fma3 \
	--disable-fma4 \
	--disable-avx2 \
	--disable-vfp \
	--disable-neon \
	--disable-inline-asm \
	--disable-yasm"

# XXX: trick to force use of embedded Libav headers
TARGET_CFLAGS += $(TARGET_CPPFLAGS) -D_GNU_SOURCE
TARGET_CPPFLAGS :=

TARGET_LDFLAGS += $(FPIC)

define Build/Prepare
$(call Build/Prepare/Default)
endef

define Package/gst1-libav/install
	$(INSTALL_DIR) $(1)/usr/lib/gstreamer-$(GST_VERSION)
	( cd $(PKG_INSTALL_DIR); $(CP) \
                ./usr/lib/gstreamer-$(GST_VERSION)/libgstlibav.so* \
                $(1)/usr/lib/gstreamer-$(GST_VERSION)/ \
        )
endef

$(eval $(call BuildPackage,gst1-libav))
