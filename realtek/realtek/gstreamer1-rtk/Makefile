#
# Copyright (C) 2008-2015 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=gstreamer1-rtk
PKG_VERSION:=1.6.4
PKG_RELEASE:=1

PKG_MAINTAINER:=W. Michael Petullo <mike@flyn.org>

PKG_LICENSE:=LGPLv2
PKG_LICENSE_FILES:=COPYING

PKG_BUILD_DIR:=$(BUILD_DIR)/gstreamer-rtk-$(PKG_VERSION)
PKG_SOURCE:=gstreamer-$(PKG_VERSION).tar.xz
PKG_SOURCE_URL:=http://gstreamer.freedesktop.org/src/gstreamer/
PKG_MD5SUM:=fb2fbf42db73ef736bdf39f50d63dd66

PKG_FIXUP:=autoreconf
PKG_REMOVE_FILES:=autogen.sh aclocal.m4

PKG_INSTALL:=1

include $(INCLUDE_DIR)/package.mk
include $(INCLUDE_DIR)/nls.mk

define Package/gstreamer1/Default
  #SECTION:=multimedia
  #CATEGORY:=Realtek NAS
  #SUBMENU:=Multimedia
  SECTION:=multimedia
  CATEGORY:=Multimedia
  TITLE:=GStreamer
  URL:=http://gstreamer.freedesktop.org/
  DEPENDS:= $(ICONV_DEPENDS) $(INTL_DEPENDS)
endef

define Package/gstreamer1/description/Default
 GStreamer open source multimedia framework
endef

GSTREAMER_CORE_LIBS:= \
	libgstreamer1 \
	libgst1check \
	libgst1controller \
	libgst1net

define Package/gstreamer1-rtk
  $(call Package/gstreamer1/Default)
  TITLE+= (All libraries)
  DEPENDS:= $(foreach lib,$(GSTREAMER_CORE_LIBS),+$(lib)-rtk)
  HIDDEN:=1
endef

define Package/gstreamer1-libs-rtk/description
 $(call Package/gstreamer1/description/Default)
 .
 This meta package contains only dependencies on the other GStreamer
 componenents.
endef

define Package/gstreamer1-libs-rtk
  $(call Package/gstreamer1/Default)
  TITLE+= core libraries
  DEPENDS+=+ALL:gstreamer1-rtk
endef

define Package/gstreamer1-libs-rtk/config
    menu "Select GStreamer libraries"
      depends on PACKAGE_gstreamer1-libs-rtk

    config gstreamer1-rtk-all
      bool "Include all GStreamer1 core libraries"
      select PACKAGE_gstreamer1-rtk

#    comment "Libraries"

 #  $(foreach lib,$(GSTREAMER_CORE_LIBS), \
 #   config PACKAGE_$(lib)
 #     prompt "GStreamer core library $(lib)"

  # )

  endmenu

endef

define Package/gstreamer1-utils-rtk
  $(call Package/gstreamer1/Default)
  TITLE+= utilities
  DEPENDS+= +libgstreamer1-rtk +gstreamer1-libs-rtk
endef

define Package/gstreamer1-utils-rtk/description
 $(call Package/gstreamer1/description/Default)
 .
 This package contains the GStreamer utilities.
endef

define Package/libgstreamer1-rtk
  $(call Package/gstreamer1/Default)
  TITLE+= library (core)
  DEPENDS+= +glib2 +libpthread +libxml2
  HIDDEN:=1
endef

define Package/libgstreamer1-rtk/description
 $(call Package/gstreamer1/description/Default)
 .
 This package contains the GStreamer core library.
endef
  

GST_VERSION:=1.0

CONFIGURE_ARGS += \
	--enable-static \
	--disable-examples \
	--disable-tests \
	--disable-valgrind \
	--without-libiconv-prefix \
	--without-libintl-prefix \
	--without-x \

TARGET_CFLAGS+= -std=gnu99

EXTRA_LDFLAGS+= \
	-Wl,-rpath-link=$(STAGING_DIR)/usr/lib \
	$(if $(ICONV_FULL),-liconv)

define Build/Prepare
	tar -C $(PKG_BUILD_DIR)/ -xf $(DL_DIR)/$(PKG_SOURCE)
	(cd $(PKG_BUILD_DIR) && mv gstreamer-$(PKG_VERSION)/* . && rm -rf gstreamer-$(PKG_VERSION))
	$(Build/Patch)
endef

define Build/InstallDev
	$(INSTALL_DIR) $(1)/usr/include/gstreamer-$(GST_VERSION)
	( cd $(PKG_INSTALL_DIR); $(CP) \
		./usr/include/gstreamer-$(GST_VERSION)/* \
		$(1)/usr/include/gstreamer-$(GST_VERSION)/ \
	)
	$(INSTALL_DIR) $(1)/usr/lib/gstreamer-$(GST_VERSION)/include/gst
	( cd $(PKG_INSTALL_DIR); $(CP) \
		./usr/lib/gstreamer-$(GST_VERSION)/include/gst/*.h \
		$(1)/usr/lib/gstreamer-$(GST_VERSION)/include/gst \
	)
	$(INSTALL_DIR) $(1)/usr/lib
	( cd $(PKG_INSTALL_DIR); $(CP) \
		./usr/lib/libgst*-$(GST_VERSION).{a,la,so*} \
		$(1)/usr/lib/ \
	)
	$(INSTALL_DIR) $(1)/usr/lib/gstreamer-$(GST_VERSION)
	( cd $(PKG_INSTALL_DIR); $(CP) \
		./usr/lib/gstreamer-$(GST_VERSION)/libgst*.{la,so} \
		$(1)/usr/lib/gstreamer-$(GST_VERSION)/ \
	)
	$(INSTALL_DIR) $(1)/usr/lib/pkgconfig
	( cd $(PKG_INSTALL_DIR); $(CP) \
		./usr/lib/pkgconfig/gstreamer*-$(GST_VERSION).pc \
		$(1)/usr/lib/pkgconfig/ \
	)
	$(INSTALL_DIR) $(2)/share/aclocal
	( cd $(PKG_INSTALL_DIR); $(CP) \
		./usr/share/aclocal/* \
		$(2)/share/aclocal/ \
	)
endef

define Package/gstreamer1-rtk/install
  true
endef

define Package/gstreamer1-libs-rtk/install
  true
endef

define Package/gstreamer1-utils-rtk/install
	$(INSTALL_DIR) $(1)/usr/bin
	( cd $(PKG_INSTALL_DIR); $(CP) \
		./usr/bin/gst-launch* \
		./usr/bin/gst-inspect* \
		./usr/bin/gst-typefind* \
		$(1)/usr/bin/ \
	)
endef

define Package/libgstreamer1-rtk/install
	$(INSTALL_DIR) $(1)/usr/lib
	( cd $(PKG_INSTALL_DIR); $(CP) \
		./usr/lib/libgstbase-$(GST_VERSION).so.* \
		./usr/lib/libgstreamer-$(GST_VERSION).so.* \
		$(1)/usr/lib/ \
	)
	$(INSTALL_DIR) $(1)/usr/lib/gstreamer-$(GST_VERSION)
	( cd $(PKG_INSTALL_DIR); $(CP) \
		./usr/lib/gstreamer-$(GST_VERSION)/libgst*.so \
		$(1)/usr/lib/gstreamer-$(GST_VERSION)/ \
	)
	$(INSTALL_BIN) $(PKG_INSTALL_DIR)/usr/lib/gstreamer-$(GST_VERSION)/gst-plugin-scanner \
		       $(1)/usr/lib/gstreamer-$(GST_VERSION)
endef


# 1: short name
# 2: description
# 3: dependencies on other gstreamer libraries (short name)
# 4: dependencies on other packages
define GstBuildLibrary

  define Package/libgst1$(1)-rtk
    $(call Package/gstreamer1/Default)
    TITLE+= $(2) library (core)
    DEPENDS+= +libgstreamer1-rtk $$(foreach p,$(3),+libgst1$$(p)-rtk) $(4)
    HIDDEN:=1
  endef

  define Package/libgst1$(1)-rtk/description
   $(call Package/gstreamer1/description/Default)
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

$(eval $(call GstBuildLibrary,check,check unit testing))
$(eval $(call GstBuildLibrary,controller,dynamic parameter control))
$(eval $(call GstBuildLibrary,net,network classes))

$(eval $(call BuildPackage,libgstreamer1-rtk))
$(eval $(call BuildPackage,gstreamer1-libs-rtk))
$(eval $(call BuildPackage,gstreamer1-utils-rtk))
$(eval $(call BuildPackage,gstreamer1-rtk))
