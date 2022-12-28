#
# Copyright (C) 2016 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=rtk-bluecore
PKG_RELEASE:=1
PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_NAME)

include $(INCLUDE_DIR)/package.mk

define Download/default
endef

define Package/rtk-bluecore
  SECTION:=multimedia
  CATEGORY:=Multimedia
#  SUBMENU:=Multimedia
  TITLE:=Bluecore Libraries
  DEPENDS:=@(TARGET_rtd1295&&!TARGET_rtd1295_mnas_emmc)
  DEFAULT:=y
endef

define Package/rtk-bluecore/description
 Realtek Bluecore libraries
endef

define Build/Prepare
endef

define Build/Compile
endef

define Package/rtk-bluecore/install
endef

$(eval $(call BuildPackage,rtk-bluecore))
