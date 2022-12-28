#
# Copyright (C) 2016 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=rtkMediaLib
#PKG_VERSION:=2017
PKG_RELEASE:=1

PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_NAME)

include $(INCLUDE_DIR)/package.mk
define Package/rtkMediaLib/Default
  SECTION:=nas
#  CATEGORY:=Realtek
#  SUBMENU:=NVR
  DEPENDS:=@TARGET_rtd1295 +openmax +alsa-lib
endef

define Package/rtkMediaLib
$(call Package/rtkMediaLib/Default)
  TITLE:=Realtek NVR kernel library
  KCONFIG:= \
  CONFIG_KALLSYMS_ALL=y \
  CONFIG_MEDIA_CAMERA_SUPPORT=y \
  CONFIG_V4L_TEST_DRIVERS=y \
  CONFIG_VIDEO_DEV=y \
  CONFIG_VIDEO_V4L2=y \
  CONFIG_VIDEO_V4L2LOOPBACK=y
endef
define Package/rtkMediaLib/description
 This package provides support libraries for network video recorder (NVR) feature
endef

define Package/rtkSoundLib
$(call Package/rtkMediaLib/Default)
  SECTION:=nas
  TITLE:=Realtek Sound library
  DEPENDS:=+rtkMediaLib +fdk-aac
endef

define Package/rtkSoundLib/description
 This package provides audio library
endef

define Build/Prepare
endef

define Build/Compile
endef

define Build/InstallDev
	$(SCRIPT_DIR)/ipkg-extract $(PKG_NAME) "$(1)" $(TOPDIR)/packages
endef

define Package/rtkMediaLib/install
	$(SCRIPT_DIR)/ipkg-extract $(PKG_NAME) "$(1)" "$(TOPDIR)/packages"
endef
define Package/rtkSoundLib/install
	$(SCRIPT_DIR)/ipkg-extract $(PKG_NAME) "$(1)" "$(TOPDIR)/packages"
endef

$(eval $(call BuildPackage,rtkMediaLib))
$(eval $(call BuildPackage,rtkSoundLib))

