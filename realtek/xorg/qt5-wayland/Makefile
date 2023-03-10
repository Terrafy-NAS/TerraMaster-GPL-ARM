#
# Copyright (C) 2013 Riccardo Ferrazzo <f.riccardo87@gmail.com>
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=qt5-wayland
PKG_VERSION:=5.8.0
PKG_RELEASE:=1
PKG_MD5SUM:=a9f2494f75f966e2f22358ec367d8f41

PKG_SOURCE:=qt-everywhere-opensource-src-$(PKG_VERSION).tar.gz
PKG_SOURCE_URL:=http://download.qt.io/archive/qt/5.8/$(PKG_VERSION)/single

PKG_BUILD_DIR=$(BUILD_DIR)/qt-everywhere-opensource-src-$(PKG_VERSION)
PKG_BUILD_PARALLEL:=1
PKG_BUILD_DEPENDS:=+libstdcpp

include $(INCLUDE_DIR)/package.mk
include ./files/qmake.mk


define Package/qt5-wayland
  SECTION:=xorg-framework
  CATEGORY:=Xorg
  SUBMENU:=framework
  TITLE:=qt5
  URL:=http://qt-project.org
  DEPENDS:=+glib2 +libstdcpp +libdbus +libdrm +fontconfig \
  +libfreetype +eudev +dejavu-fonts-ttf \
  +mali-wayland +libpng +libxkbcommon +libudev \
  +libmtdev +libinput +libiconv-full +supportlibs +libjpeg +libwayland

endef

EXTRA_CFLAGS += -DWL_EGL_PLATFORM
EXTRA_LDFLAGS += -Wl,-rpath-link=$(STAGING_DIR)/lib
ifeq ($(CONFIG_EXTERNAL_TOOLCHAIN),)
EXTRA_LDFLAGS += -Wl,-rpath-link=$(TOOLCHAIN_DIR)/lib
else
EXTRA_LDFLAGS += -Wl,-rpath-link=$(CONFIG_TOOLCHAIN_ROOT)/lib
endif

define Build/Configure
	mkdir -p $(PKG_BUILD_DIR)/qtbase/mkspecs/linux-openwrt-g++
	$(CP) ./files/$(FILEPFX)qmake.conf $(PKG_BUILD_DIR)/qtbase/mkspecs/linux-openwrt-g++/qmake.conf
	$(CP) ./files/$(FILEPFX)qplatformdefs.h $(PKG_BUILD_DIR)/qtbase/mkspecs/linux-openwrt-g++/qplatformdefs.h
	( cd $(PKG_BUILD_DIR) ; \
		TARGET_CC="$(TARGET_CROSS)gcc" \
		TARGET_CXX="$(TARGET_CROSS)g++" \
		TARGET_AR="$(TARGET_CROSS)ar cqs" \
		TARGET_OBJCOPY="$(TARGET_CROSS)objcopy" \
		TARGET_RANLIB="$(TARGET_CROSS)ranlib" \
		TARGET_CFLAGS="$(TARGET_CFLAGS) $(EXTRA_CFLAGS)" \
		TARGET_CXXFLAGS="$(TARGET_CFLAGS) $(EXTRA_CFLAGS)" \
		TARGET_LDFLAGS="$(TARGET_LDFLAGS) $(EXTRA_LDFLAGS)" \
		TARGET_INCDIRS="$(TARGET_INCDIRS)" \
		TARGET_LIBDIRS="$(TARGET_LIBDIRS)" \
		PKG_CONFIG_SYSROOT_DIR="/" \
		CFLAGS= \
		CXXFLAGS= \
		LDFLAGS= \
		STAGING_DIR="$(STAGING_DIR)" \
		STAGING_DIR_HOST="$(STAGING_DIR)/../host" \
		./configure \
			-prefix $(CONFIGURE_PREFIX) \
			-bindir $(CONFIGURE_PREFIX)/bin \
			-libdir $(CONFIGURE_PREFIX)/lib \
			-datadir $(CONFIGURE_PREFIX)/share/Qt \
			-plugindir $(CONFIGURE_PREFIX)/lib/Qt/plugins \
			-examplesdir $(CONFIGURE_PREFIX)/share/Qt/examples \
			-sysroot $(STAGING_DIR) \
			-pkg-config \
			-xplatform linux-openwrt-g++ \
			-opensource \
			-confirm-license \
			-make examples \
			-nomake tests \
			-no-xcb \
			-skip qtcanvas3d \
			-skip qtlocation \
			-skip qtscxml \
			-skip qtcharts \
			-skip qtmacextras \
			-skip qtsensors \
			-skip qtwebchannel \
			-skip qtconnectivity \
			-skip qtserialbus \
			-skip qtwebengine \
			-skip qtdatavis3d \
			-skip qtmultimedia \
			-skip qtnetworkauth \
			-skip qtserialport \
			-skip qtwebsockets \
			-skip qtspeech \
			-skip qtwebview \
			-skip qt3d \
			-skip qtdoc \
			-skip qtpurchasing \
			-skip qtsvg \
			-skip qtwinextras \
			-skip qtactiveqt \
			-skip qtgamepad \
			-skip qtquickcontrols \
			-skip qttools \
			-skip qtx11extras \
			-skip qtandroidextras \
			-skip qtgraphicaleffects \
			-skip qtquickcontrols2 \
			-skip qttranslations \
			-skip qtimageformats \
			-skip qtscript \
			-skip qtvirtualkeyboard \
			-v \
	)
endef

define Build/Compile
	TARGET_CC="$(TARGET_CROSS)gcc" \
	TARGET_CXX="$(TARGET_CROSS)g++" \
	TARGET_AR="$(TARGET_CROSS)ar cqs" \
	TARGET_OBJCOPY="$(TARGET_CROSS)objcopy" \
	TARGET_RANLIB="$(TARGET_CROSS)ranlib" \
	TARGET_CFLAGS="$(TARGET_CFLAGS) $(EXTRA_CFLAGS)" \
	TARGET_CXXFLAGS="$(TARGET_CFLAGS) $(EXTRA_CFLAGS)" \
	TARGET_LDFLAGS="$(TARGET_LDFLAGS) $(EXTRA_LDFLAGS)" \
	TARGET_INCDIRS="$(TARGET_INCDIRS)" \
	TARGET_LIBDIRS="$(TARGET_LIBDIRS)" \
	STAGING_DIR="$(STAGING_DIR)" \
	STAGING_DIR_HOST="$(STAGING_DIR)/../host" \
	PKG_CONFIG_SYSROOT_DIR="/" \
	$(MAKE) -C $(PKG_BUILD_DIR) -j$(shell grep -c ^processor /proc/cpuinfo)
	INSTALL_ROOT=$(PKG_INSTALL_DIR) \
	$(MAKE) -C $(PKG_BUILD_DIR) install
endef

define Build/InstallDev
	$(INSTALL_DIR) $(2)/bin
	$(INSTALL_DIR) $(1)/bin
	$(INSTALL_DIR) $(1)/usr/mkspecs
	$(INSTALL_DIR) $(1)/usr/bin
	$(INSTALL_DIR) $(1)/usr/include
	$(INSTALL_DIR) $(1)/usr/lib
	$(INSTALL_DIR) $(1)/usr/lib/pkgconfig
	$(INSTALL_DIR) $(1)/usr/lib/cmake
	$(INSTALL_DIR) $(1)/usr/lib/Qt/plugins

	$(INSTALL_DIR) $(STAGING_DIR)/mk/
	$(INSTALL_DATA) ./files/qmake.mk $(STAGING_DIR)/mk/

	$(CP) \
		$(PKG_INSTALL_DIR)$(STAGING_DIR)/usr/bin/* \
		$(2)/bin/

	$(CP) \
		$(PKG_INSTALL_DIR)$(STAGING_DIR)/usr/bin/* \
		$(1)/usr/bin/

	$(CP) \
		$(PKG_INSTALL_DIR)$(STAGING_DIR)/usr/mkspecs/* \
		$(1)/usr/mkspecs/

	$(CP) \
		$(PKG_INSTALL_DIR)$(STAGING_DIR)/usr/lib/pkgconfig/* \
		$(1)/usr/lib/pkgconfig/

	$(CP) \
		$(PKG_INSTALL_DIR)$(STAGING_DIR)/usr/include/* \
		$(1)/usr/include/

	$(CP) \
		$(PKG_INSTALL_DIR)$(STAGING_DIR)/usr/lib/*.so* \
		$(1)/usr/lib/

	$(CP) \
		$(PKG_INSTALL_DIR)$(STAGING_DIR)/usr/lib/*.prl* \
		$(1)/usr/lib/

	$(CP) \
		$(PKG_INSTALL_DIR)$(STAGING_DIR)/usr/lib/*.la* \
		$(1)/usr/lib/

	$(CP) \
		$(PKG_INSTALL_DIR)$(STAGING_DIR)/usr/lib/cmake/* \
		$(1)/usr/lib/cmake/

	$(CP) -r \
		$(PKG_INSTALL_DIR)$(STAGING_DIR)/usr/lib/Qt/plugins/* \
		$(1)/usr/lib/Qt/plugins/
endef

define Package/qt5-wayland/install
	$(INSTALL_DIR) $(1)/usr/lib/
	$(CP) \
		$(PKG_INSTALL_DIR)$(STAGING_DIR)/usr/lib/libQt5* \
		$(1)/usr/lib/
	$(INSTALL_DIR) $(1)/usr/lib/

	$(CP) \
		$(PKG_INSTALL_DIR)$(STAGING_DIR)/usr/lib/libQt5Gui.so* \
		$(1)/usr/lib/
	$(CP) \
		$(PKG_INSTALL_DIR)$(STAGING_DIR)/usr/lib/libQt5Gui.prl \
		$(1)/usr/lib/
	$(CP) \
		$(PKG_INSTALL_DIR)$(STAGING_DIR)/usr/lib/libQt5Gui.la \
		$(1)/usr/lib/
	#Qt5 requires truetype fonts stored in /usr/lib/fonts - no subdirectories allowed, so use the dejavue set by default
	ln -s \
		/usr/share/fonts/ttf-dejavu \
		$(1)/usr/lib/fonts
	$(INSTALL_DIR) $(1)/usr/share/Qt

	$(CP) \
		$(PKG_INSTALL_DIR)$(STAGING_DIR)/usr/share/Qt/examples \
		$(1)/usr/share/Qt/

	$(FIND) \
		$(1) \
		-name "*.cpp" -o \
		-name "*.h" -o \
		-name "*.pro" \
		| $(XARGS) rm
	$(INSTALL_DIR) $(1)/usr/lib/Qt/plugins/
	$(CP) -r \
		$(PKG_INSTALL_DIR)$(STAGING_DIR)/usr/lib/Qt/plugins/generic \
		$(1)/usr/lib/Qt/plugins/
	$(CP) -r \
		$(PKG_INSTALL_DIR)$(STAGING_DIR)/usr/lib/Qt/plugins/imageformats \
		$(1)/usr/lib/Qt/plugins/
	$(CP) -r \
		$(PKG_INSTALL_DIR)$(STAGING_DIR)/usr/lib/Qt/plugins/platforminputcontexts \
		$(1)/usr/lib/Qt/plugins/
	$(CP) -r \
		$(PKG_INSTALL_DIR)$(STAGING_DIR)/usr/lib/Qt/plugins/platforms \
		$(1)/usr/lib/Qt/plugins/

#	$(CP) -r \
		$(PKG_INSTALL_DIR)$(STAGING_DIR)/usr/lib/Qt/plugins/egldeviceintegrations \
		$(1)/usr/lib/Qt/plugins/

	$(CP) -r \
		$(PKG_INSTALL_DIR)$(STAGING_DIR)/usr/lib/Qt/plugins/wayland* \
		$(1)/usr/lib/Qt/plugins/

	$(INSTALL_DIR) $(1)/usr/lib/Qt/plugins/generic/
	$(CP) \
		$(PKG_INSTALL_DIR)$(STAGING_DIR)/usr/lib/Qt/plugins/generic/libqevdevkeyboardplugin.so* \
		$(1)/usr/lib/Qt/plugins/generic/
	$(INSTALL_DIR) $(1)/usr/lib/Qt/plugins/generic/
	$(CP) \
		$(PKG_INSTALL_DIR)$(STAGING_DIR)/usr/lib/Qt/plugins/generic/libqevdevmouseplugin.so* \
		$(1)/usr/lib/Qt/plugins/generic/
endef

$(eval $(call BuildPackage,qt5-wayland))
#$(eval $(call BuildPackage,qt5-gui))
#$(eval $(call BuildPackage,qt5-examples))
#$(eval $(call BuildPackage,qt5-plugin-platforms))
#$(eval $(call BuildPackage,qt5-plugin-input-evdevkeyboard))
#$(eval $(call BuildPackage,qt5-plugin-input-evdevmouse))
