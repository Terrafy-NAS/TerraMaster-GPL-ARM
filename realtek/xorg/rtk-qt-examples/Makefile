#
# Copyright (C) 2016 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=rtk-qt-examples
#PKG_VERSION:=2017
PKG_RELEASE:=1

PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_NAME)

PKG_BUILD_DEPENDS:=+libstdcpp
include $(INCLUDE_DIR)/package.mk
define Package/rtk-qt-examples
  SECTION:=nas
  CATEGORY:=Realtek
  TITLE:=QT examples for Realtek
  DEPENDS:=@TARGET_rtd1295 \
	+rtk-nvr +rtkMediaLib \
	+qt5-wayland
endef
define Package/rtk-qt-examples/description
  This package activates qt examples for Realtek
endef
define Build/Prepare
endef

define Build/Compile
endef

define Build/InstallDev

endef

define Package/rtk-qt-examples/install
	$(SCRIPT_DIR)/ipkg-extract $(PKG_NAME) "$(1)" "$(TOPDIR)/packages"

	$(CP) \
		$(1)/usr/share/Qt/examples/qt_rtk_examples/* \
		$(1)/usr/share/
endef

$(eval $(call BuildPackage,rtk-qt-examples))

