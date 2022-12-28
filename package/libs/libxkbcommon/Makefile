#
# Copyright (C) 2007-2010 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#
# blogic@openwrt.org

include $(TOPDIR)/rules.mk

PKG_NAME:=libxkbcommon
PKG_RELEASE:=1
PKG_VERSION:=0.7.1

PKG_SOURCE_URL:=http://xkbcommon.org/download/
PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION).tar.xz
PKG_BUILD_DIR:=$(BUILD_DIR)/Xorg/$(PKG_NAME)-$(PKG_VERSION)/
PKG_MD5SUM:=947ba609cb0239b9462127d5cf8908ee
PKG_FIXUP:=libtool
PKG_INSTALL:=1

include $(INCLUDE_DIR)/package.mk

define Package/libxkbcommon
  SECTION:=xorg-libraries
  CATEGORY:=Xorg
  SUBMENU:=libraries
  DEPENDS:=
  TITLE:=libxkbcommon
  URL:=http://xorg.freedesktop.org/
endef

define Package/libxkbcommon/description
	xkbcommon is a library to handle keyboard descriptions, including
	loading them from disk, parsing them and handling their state.
	It's mainly meant for client toolkits, window systems, and other
	system applications; currently that includes Wayland, kmscon,
	GTK+, Qt, Clutter, and more. Despite the name, it isn't actually
	used by anything X11 (yet).
endef

TARGET_CFLAGS+= -std=c99

CONFIGURE_ARGS+= --disable-docs \
	--prefix=/usr \
	--disable-runtime-deps \
	--with-xkb-config-root=/usr/share/X11/xkb \
	--disable-x11

define Build/InstallDev
	$(INSTALL_DIR) $(1)/usr/include/xkbcommon
	$(CP) \
		$(PKG_INSTALL_DIR)/usr/include/xkbcommon/*.h \
		$(1)/usr/include/xkbcommon/
	$(INSTALL_DIR) $(1)/usr/lib/pkgconfig
	$(CP) \
		$(PKG_INSTALL_DIR)/usr/lib/*.{so*,a,la} \
		$(1)/usr/lib/
	$(INSTALL_DATA) \
		$(PKG_INSTALL_DIR)/usr/lib/pkgconfig/* \
		$(1)/usr/lib/pkgconfig/
endef

define Package/libxkbcommon/install
	$(INSTALL_DIR) $(1)/usr/lib
	$(CP) \
		$(PKG_INSTALL_DIR)/usr/lib/*.so* \
		$(1)/usr/lib/
	$(INSTALL_DIR) $(1)/usr/
	$(INSTALL_DIR) $(1)/usr/share
	$(INSTALL_DIR) $(1)/usr/share/X11
	$(INSTALL_DIR) $(1)/usr/share/X11/xkb
	$(INSTALL_DIR) $(1)/usr/share/X11/xkb/{rules,types,keycodes,keymaps,compat,symbols}

	$(CP) \
		$(PKG_BUILD_DIR)/test/data/rules/* \
		$(1)/usr/share/X11/xkb/rules/
	$(CP) \
		$(PKG_BUILD_DIR)/test/data/types/* \
		$(1)/usr/share/X11/xkb/types/
	$(CP) \
		$(PKG_BUILD_DIR)/test/data/keycodes/* \
		$(1)/usr/share/X11/xkb/keycodes/
	$(CP) \
		$(PKG_BUILD_DIR)/test/data/keymaps/* \
		$(1)/usr/share/X11/xkb/keymaps/
	$(CP) \
		$(PKG_BUILD_DIR)/test/data/compat/* \
		$(1)/usr/share/X11/xkb/compat/
	$(CP) \
		$(PKG_BUILD_DIR)/test/data/symbols/* \
		$(1)/usr/share/X11/xkb/symbols/
endef

$(eval $(call BuildPackage,libxkbcommon))
