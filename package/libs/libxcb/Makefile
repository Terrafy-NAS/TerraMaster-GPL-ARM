#
# Copyright (C) 2008-2010 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=libxcb
PKG_VERSION:=1.12
PKG_RELEASE:=1

PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION).tar.bz2
PKG_SOURCE_URL:=http://xcb.freedesktop.org/dist/
PKG_MD5SUM:=28e552bd78bc1050b6b26ca1db0e5bb6
PKG_FIXUP:=libtool
PKG_INSTALL:=1
PKG_BUILD_DEPENDS:= \
	xcbproto \
	libpthread-stubs \
	xsltproc

include $(INCLUDE_DIR)/package.mk

#PROTOS:=composite damage dpms dri2 dri3 glx present randr record render res \
	screensaver shape shm sync xevie xf86dri xfixes xinerama xprint \
	xtest xv xvmc

define Package/libxcb
  SECTION:=libs
  CATEGORY:=Libraries
  TITLE:=Xcb Libraries
  DEPENDS:=+libXau +libXdmcp
  URL:=http://xcb.freedesktop.org/
endef

define Package/libxcb/description
libxcb provides an interface to the X Window System protocol, which
replaces the current Xlib interface.
endef

define Package/libxcb-proto/Default
define Package/libxcb-$(1)
  SECTION:=xorg-framework
  CATEGORY:=Xorg
  SUBMENU:=xcb
  TITLE:=libxcb-$(1)
  DEPENDS:=
endef
endef

CONFIGURE_VARS += \
	XSLTPROC=$(STAGING_DIR_ROOT)/usr/bin/xsltproc \
	CFLAGS="$(TARGET_CFLAGS) -std=gnu99"

$(foreach proto,$(PROTOS),$(eval $(call Package/libxcb-proto/Default,$(proto))))

define Build/InstallDev
	$(INSTALL_DIR) $(1)/usr/{lib/pkgconfig,include/xcb}
	$(INSTALL_DATA) \
		$(PKG_INSTALL_DIR)/usr/include/xcb/* \
		$(1)/usr/include/xcb/

	$(CP) \
		$(PKG_INSTALL_DIR)/usr/lib/*.{so*,a,la} \
		$(1)/usr/lib/

	$(INSTALL_DATA) \
		$(PKG_INSTALL_DIR)/usr/lib/pkgconfig/* \
		$(1)/usr/lib/pkgconfig/
endef

define Package/libxcb/install
	$(INSTALL_DIR) $(1)/usr/lib
	$(CP) \
		$(PKG_INSTALL_DIR)/usr/lib/*.{so*,a,la} $(1)/usr/lib/
		#$(PKG_INSTALL_DIR)/usr/lib/libxcb.so* $(1)/usr/lib/
endef

define Package/libxcb-proto/install/Default
define Package/libxcb-$(1)/install
	$(INSTALL_DIR) $$(1)/usr/lib
	$(CP) \
		$(PKG_INSTALL_DIR)/usr/lib/libxcb-$(1).so* \
		$$(1)/usr/lib/
endef
endef

$(foreach proto,$(PROTOS),$(eval $(call Package/libxcb-proto/install/Default,$(proto))))

$(eval $(call BuildPackage,libxcb))
$(foreach proto,$(PROTOS),$(eval $(call BuildPackage,libxcb-$(proto))))
