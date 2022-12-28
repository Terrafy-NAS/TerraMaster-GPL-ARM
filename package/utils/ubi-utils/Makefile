#
# Copyright (C) 2009-2014 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=ubi-utils
PKG_REV:=7d2839b8dede3ae368780364b4a07473d2303219
PKG_VERSION:=1.5.1
PKG_RELEASE:=2

PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION).tar.gz
PKG_SOURCE_URL:=git://git.infradead.org/mtd-utils.git
PKG_SOURCE_PROTO:=git
PKG_SOURCE_SUBDIR:=$(PKG_NAME)-$(PKG_VERSION)
PKG_SOURCE_VERSION:=$(PKG_REV)
PKG_MIRROR_MD5SUM:=69b68adcfcbe786584771e5978534ab4

PKG_INSTALL:=1

PKG_BUILD_DEPENDS:=util-linux liblzo zlib

PKG_LICENSE:=GPLv2
PKG_LICENSE_FILES:=

PKG_MAINTAINER:=John Crispin <blogic@openwrt.org>

include $(INCLUDE_DIR)/package.mk

define Package/ubi-utils
  TITLE:=Utilities for ubi info/debug
  SECTION:=utils
  CATEGORY:=Utilities
  URL:=http://www.linux-mtd.infradead.org/
  DEPENDS:=@NAND_SUPPORT
endef

define Package/ubi-utils/description
  Utilities for manipulating memory technology devices.
endef

define Package/ubi-tests
  TITLE:=Utilities for ubi tests
  SECTION:=utils
  CATEGORY:=Utilities
  DEPENDS:=@NAND_SUPPORT +ubi-utils
endef

define Package/ubi-tests/description
  Utilities for testing UBI.
endef

MAKE_FLAGS += \
	DESTDIR="$(PKG_INSTALL_DIR)" \
	BUILDDIR="$(PKG_BUILD_DIR)" \
	WITHOUT_XATTR=1 \
	WITHOUT_LZO=1

define Build/Compile
	$(call Build/Compile/Default)
	$(call Build/Compile/Default,tests)
endef

define Package/ubi-utils/install
	$(INSTALL_DIR) $(1)/usr/sbin
	$(INSTALL_BIN) \
		$(PKG_INSTALL_DIR)/usr/sbin/{ubiattach,ubicrc32,ubiblock,ubidetach,ubiformat,ubimkvol} $(1)/usr/sbin/
	$(INSTALL_BIN) \
		$(PKG_INSTALL_DIR)/usr/sbin/{ubinfo,ubinize,ubirename,ubirmvol,ubirsvol,ubiupdatevol} $(1)/usr/sbin/
endef

define Package/ubi-tests/install
	$(INSTALL_DIR) $(1)/usr/local/sbin
	$(INSTALL_BIN) \
		$(PKG_BUILD_DIR)/{integ,io_basic,io_paral,io_read,io_update,mkvol_bad,mkvol_basic,mkvol_paral,rsvol,volrefcnt} $(1)/usr/local/sbin/
	$(INSTALL_BIN) \
		$(PKG_BUILD_DIR)/tests/ubi-tests/{runtests.sh,stress-test.sh} $(1)/usr/local/sbin/
	$(INSTALL_BIN) \
		$(PKG_BUILD_DIR)/tests/fs-tests/integrity/integck $(1)/usr/local/sbin/
endef

$(eval $(call BuildPackage,ubi-utils))
$(eval $(call BuildPackage,ubi-tests))
