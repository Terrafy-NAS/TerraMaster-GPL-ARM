#
# Copyright (C) 2009-2015 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=gst1-plugins-ugly-rtk
PKG_VERSION:=1.6.4
PKG_RELEASE:=1

PKG_MAINTAINER:=W. Michael Petullo <mike@flyn.org>

PKG_LICENSE:=LGPLv2
PKG_LICENSE_FILES:=COPYING

PKG_BUILD_DIR:=$(BUILD_DIR)/gst-plugins-ugly-rtk-$(PKG_VERSION)
PKG_SOURCE:=gst-plugins-ugly-$(PKG_VERSION).tar.xz
PKG_SOURCE_URL:=http://gstreamer.freedesktop.org/src/gst-plugins-ugly/
PKG_MD5SUM:=1acdb29ede2e72bed4e7c6714a6aac5c

PKG_BUILD_DEPENDS:= libgstreamer1-rtk gstreamer1-plugins-base-rtk
PKG_CONFIG_DEPENDS:= \
	CONFIG_PACKAGE_gst1-mod-asf-rtk \
	CONFIG_PACKAGE_gst1-mod-lame-rtk \
	CONFIG_PACKAGE_gst1-mod-mad-rtk \
	CONFIG_PACKAGE_gst1-mod-mpeg2dec-rtk \

PKG_FIXUP:=autoreconf
PKG_INSTALL:=1

include $(INCLUDE_DIR)/package.mk
include $(INCLUDE_DIR)/nls.mk

GST_UGLY_MODULES:=

define Package/gstreamer1-ugly/Default
  #SECTION:=multimedia
  #CATEGORY:=Realtek NAS
  #SUBMENU:=Multimedia
  SECTION:=multimedia
  CATEGORY:=Multimedia
  TITLE:=GStreamer
  URL:=http://gstreamer.freedesktop.org/
  DEPENDS:= +libgstreamer1-rtk $(ICONV_DEPENDS)
endef

define Package/gstreamer1-ugly/description/Default
 GStreamer open source multimedia framework
endef


define Package/gst1-plugins-ugly-rtk
$(call Package/gstreamer1-ugly/Default)
  TITLE+= plugins collection (ugly)
  DEPENDS+= $(GST_DEPENDS)
  HIDDEN:=1
endef

define Package/gts-plugins-ugly-rtk/description
$(call Package/gstreamer1-ugly/description/Default)
 .
 This meta package contains only dependencies to the other plugins from
 the ugly plugins collection.
endef


define Package/gstreamer1-plugins-ugly-rtk
  $(call Package/gstreamer1-ugly/Default)
  TITLE+= plugins collection (ugly)
  DEPENDS:=+ALL:gst1-plugins-ugly-rtk +gstreamer1-plugins-base-rtk
endef

define Package/gstreamer1-plugins-ugly-rtk/config
    menu "Select GStreamer ugly modules"
      depends on PACKAGE_gstreamer1-plugins-ugly-rtk


    config gst1-plugins-ugly-rtk-all
      bool "Include all GStreamer ugly plugins"
      select PACKAGE_gst1-plugins-ugly-rtk

    comment "Modules"

   $(foreach mod,$(GST_UGLY_MODULES), \
    config PACKAGE_gst1-mod-$(mod)-rtk
      prompt "GStreamer $(mod) module"

   )

  endmenu

endef

GST_COND_SELECT = $(patsubst %,$(if $(CONFIG_PACKAGE_gst1-mod-$(1)-rtk),--enable,--disable)-%,$(1))

GST_VERSION:=1.0

CONFIGURE_ARGS += \
	--disable-debug \
	--disable-examples \
	\
	--disable-a52dec \
	--disable-amrnb \
	--disable-amrwb \
	$(call GST_COND_SELECT,asf) \
	--disable-cdio \
	--disable-dvdlpcmdec \
	--disable-dvdread \
	--disable-dvdsub \
	--disable-iec958 \
	$(call GST_COND_SELECT,lame) \
	$(call GST_COND_SELECT,mad) \
	$(call GST_COND_SELECT,mpeg2dec) \
	--disable-mpegaudioparse \
	--disable-mpegstream \
	--disable-sidplay \
	--disable-synaesthesia \
	--disable-twolame \
	--disable-x264 \
	\
	--without-libiconv-prefix \
	--without-libintl-prefix \

EXTRA_LDFLAGS+= \
	-Wl,-rpath-link=$(STAGING_DIR)/usr/lib \
	$(if $(ICONV_FULL),-liconv) \


define Build/Prepare
	tar -C $(PKG_BUILD_DIR)/ -xf $(DL_DIR)/$(PKG_SOURCE)
	(cd $(PKG_BUILD_DIR) && mv gst-plugins-ugly-$(PKG_VERSION)/* . && rm -rf gst-plugins-ugly-$(PKG_VERSION))
	$(Build/Patch)
endef

define Package/gst1-plugins-ugly-rtk/install
	/bin/true
endef


# 1: short name
# 2: description
# 3: dependencies on other gstreamer libraries (short name)
# 4: dependencies on other gstreamer plugins (short name)
# 5: dependencies on other packages
define GstBuildPlugin

  GST_DEPENDS += +gst1-mod-$(1)-rtk

  GST_UGLY_MODULES+= $(1)

  define Package/gst1-mod-$(1)-rtk
    $(call Package/gstreamer1-ugly/Default)
    TITLE+= $(2) plugin (ugly)
    DEPENDS+= +libgstreamer1-rtk $$(foreach p,$(3),+libgst1$$(p)-rtk) $$(foreach p,$(4),+gst1-mod-$$(p)-rtk) $(5)
    HIDDEN:=1
  endef

  define Package/gst1-mod-$(1)-rtk/description
   $(call Package/gstreamer1-ugly/description/Default)
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

$(eval $(call GstBuildPlugin,asf,ASF demuxer,audio video riff rtp rtsp sdp tag,,))
$(eval $(call GstBuildPlugin,lame,MP3 encoder (using LAME),audio,,+lame-lib))
$(eval $(call GstBuildPlugin,mad,MP3 decoder (using MAD),audio tag,,+libid3tag +libmad))
$(eval $(call GstBuildPlugin,mpeg2dec,MPEG decoder,video,,+libmpeg2))
$(eval $(call GstBuildPlugin,rmdemux,RealMedia demuxer,pbutils rtsp sdp,,))

$(eval $(call BuildPackage,gstreamer1-plugins-ugly-rtk))
$(eval $(call BuildPackage,gst1-plugins-ugly-rtk))
