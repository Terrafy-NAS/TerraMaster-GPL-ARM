#
# Copyright (C) 2006-2015 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=libminigui-gpl
PKG_VERSION:=3.0.12
PKG_RELEASE:=1

PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION).tar.gz
PKG_SOURCE_URL:=http://www.minigui.org/downloads/
PKG_MD5SUM:=c09dbc378344945460b5142956d2cd34

PKG_LICENSE:=GPLv3
PKC_LICENSE_FILES:=COPYING

PKG_FIXUP:=autoreconf
PKG_INSTALL:=1

include $(INCLUDE_DIR)/package.mk

define Package/libminigui-gpl
  SECTION:=multimedia
#  CATEGORY:=Realtek NAS
#  SUBMENU:=Multimedia
  DEPENDS:=+libpng
  TITLE:=MiniGUI
  URL:=http://www.minigui.org
endef


define Build/Configure
	$(call Build/Configure/Default, \
		--prefix=/usr/local \
		--enable-pngsupport \
	)
endef

define Build/Compile
	(cd $(PKG_BUILD_DIR); \
		sed -i -e 's/^oldincludedir.*//g' src/newgal/pcxvfb/Makefile; \
		sed -i -e 's/-I\/usr\/include\///g' src/newgal/pcxvfb/Makefile; \
	);
	$(MAKE) -C $(PKG_BUILD_DIR) \
		DESTDIR="$(PKG_INSTALL_DIR)" \
		install
endef

define Build/InstallDev
	mkdir -p $(1)/usr/include/minigui
	$(CP)	$(PKG_INSTALL_DIR)/usr/local/include/minigui/* \
		$(1)/usr/include/minigui
	mkdir -p $(1)/usr/lib
	$(CP)	$(PKG_INSTALL_DIR)/usr/lib/libminigui_ths.{a,la,so} \
		$(1)/usr/lib/
	$(CP)	$(PKG_INSTALL_DIR)/usr/lib/libminigui_ths-3.0.so.* \
		$(1)/usr/lib/
	mkdir -p $(1)/usr/lib/pkgconfig
	$(CP)	$(PKG_INSTALL_DIR)/usr/lib/pkgconfig/minigui.pc \
		$(1)/usr/lib/pkgconfig/
endef

define Package/libminigui-gpl/install
	$(INSTALL_DIR) $(1)/usr/lib
	$(CP) $(PKG_INSTALL_DIR)/usr/lib/libminigui_ths.so $(1)/usr/lib/
	$(CP) $(PKG_INSTALL_DIR)/usr/lib/libminigui_ths-3.0.so.* $(1)/usr/lib/
	$(INSTALL_DIR) $(1)/usr/local/etc
	$(CP) $(PKG_INSTALL_DIR)/usr/local/etc/MiniGUI.cfg $(1)/usr/local/etc
	#sed -i -e 's/gal_engine=pc_xvfb/gal_engine=fbcon/g' $(1)/usr/local/etc/MiniGUI.cfg;
	#sed -i -e 's/^defaultmode=.*/defaultmode=1920x1080-32bpp/g' $(1)/usr/local/etc/MiniGUI.cfg;
	#sed -i -e 's/ial_engine=pc_xvfb/ial_engine=console/g' $(1)/usr/local/etc/MiniGUI.cfg;
	#sed -i -e 's/cursorpath=.*/cursorpath=\/usr\/share\/minigui\/res\/cursor\//g' $(1)/usr/local/etc/MiniGUI.cfg;
	#sed -i -e 's/respath=.*/respath=\/usr\/share\/minigui\/res\//g' $(1)/usr/local/etc/MiniGUI.cfg;
	$(INSTALL_DIR) $(1)/usr/share
	mkdir -p $(1)/usr/share/minigui
	$(CP) $(PKG_INSTALL_DIR)/usr/share/minigui/cmake $(1)/usr/share/minigui/cmake
endef

$(eval $(call BuildPackage,libminigui-gpl))
