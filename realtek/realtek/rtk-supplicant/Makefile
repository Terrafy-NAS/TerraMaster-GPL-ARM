
# Copyright (C) 2017 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=rtk-supplicant
PKG_RELEASE:=1
PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_NAME)
PKG_BUILD_DEPENDS:=gstreamer-hw-transcode rtk-transcode supportlibs rtkMediaLib

include $(INCLUDE_DIR)/package.mk

define Download/default
endef

define Package/rtk-supplicant
  SECTION:=nas
#  CATEGORY:=Realtek
  TITLE:=Supplicant
#  SUBMENU:=NAS
  DEPENDS:=@TARGET_rtd1295 \
	 +gstreamer1-libs-rtk +gstreamer1-rtk \
	 +gstreamer1-utils-rtk \
	 +gstreamer1-plugins-base-rtk +libgst1app-rtk +gst1-mod-app-rtk +PACKAGE_rtk-nvr-full:gst1-plugins-base-rtk \
	 +gstreamer1-plugins-good-rtk +PACKAGE_rtk-nvr-full:gst1-plugins-good-rtk \
	 +gstreamer1-plugins-bad-rtk +PACKAGE_rtk-nvr-full:gst1-plugins-bad-rtk \
	 +gstreamer1-plugins-ugly-rtk +PACKAGE_rtk-nvr-full:gst1-plugins-ugly-rtk \
	 +gstreamer1-plugins-rtk \
	 +gst1-omx-1-2 \
	 +PACKAGE_rtk-nvr-full:gst1-libav +supportlibs +rtkMediaLib
endef

define Package/rtk-supplicant/description
 This package activates
endef

define Build/Prepare
	($(CP) ./src/* $(PKG_BUILD_DIR))
endef
define Package/rtk-supplicant/install
	$(SCRIPT_DIR)/ipkg-extract $(PKG_NAME) "$(PKG_BUILD_DIR)" "$(TOPDIR)/packages" ./usr/
	$(INSTALL_DIR) $(1)/etc/init.d
	$(INSTALL_DIR) $(1)/usr/bin
	$(INSTALL_BIN) ./files/rtk-supplicant.init $(1)/etc/init.d/rtk-supplicant
  ifeq ($(CONFIG_PACKAGE_rtk-nvr),y)
#	$(INSTALL_BIN) ./files/rtk-nvr.init $(1)/etc/init.d/rtk-supplicant
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/usr/bin/ALSADaemon-GUI $(1)/usr/bin/rtk-supplicant
	# NVR testing applications
	$(INSTALL_DIR) $(1)/root
	#$(INSTALL_BIN) $(PKG_BUILD_DIR)/testapp-rtspclient-disp $(1)/root/
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/test-rtspclient $(1)/root/
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/testapp-thumbnail $(1)/root/
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/testapp-debug $(1)/root/
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/testapp-slim-rtkrtsp-fetchframe $(1)/root/
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/testapp-adec $(1)/root/
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/testapp-aenc $(1)/root/
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/testapp-aenc2dec $(1)/root/
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/*.sh $(1)/root/
  else ifeq ($(CONFIG_PACKAGE_rtk-transcode),y)
#	$(INSTALL_BIN) ./files/openmax.init $(1)/etc/init.d/openmax
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/usr/bin/ALSADaemon $(1)/usr/bin/rtk-supplicant
  else ifeq ($(CONFIG_TARGET_rtd1295_nas_spi)$(CONFIG_PACKAGE_kmod-mali-wayland),yy)
#	$(INSTALL_BIN) ./files/gui.init $(1)/etc/init.d/rtk-supplicant
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/usr/bin/ALSADaemon-GUI $(1)/usr/bin/rtk-supplicant
  endif
	rm -rf "$(PKG_BUILD_DIR)/usr"
endef

$(eval $(call BuildPackage,rtk-supplicant))
