#
# Copyright (C) 2011 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=live
PKG_VERSION:=2017.01.26
PKG_RELEASE:=2

PKG_SOURCE:=$(PKG_NAME).$(PKG_VERSION).tar.gz
PKG_SOURCE_URL:=http://www.live555.com/liveMedia/public/
PKG_MD5SUM:=9656e2e818cb2f34987ded2593802fba

PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_NAME)

include $(INCLUDE_DIR)/package.mk

define Package/openrtsp
  SECTION:=video
  CATEGORY:=Video Streaming
  TITLE:=live555 streaming libraries and testProgs
  URL:=http://www.live555.com/
  DEPENDS:=+libstdcpp
endef

define Build/Configure
	( cd $(PKG_BUILD_DIR); \
		$(SED) 's/@CROSS_COMPILE@/$(TARGET_CROSS)/g' \
		    -e 's/@CFLAGS@/$(TARGET_CFLAGS)/g' \
		    config.OpenWrt; \
		./genMakefiles OpenWrt; \
	)
endef

define Package/openrtsp/install
	$(INSTALL_DIR) $(1)/usr/bin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/testProgs/openRTSP $(1)/usr/bin/
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/proxyServer/live555ProxyServer $(1)/usr/bin/
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/mediaServer/live555MediaServer $(1)/usr/bin/
endef

$(eval $(call BuildPackage,openrtsp))
