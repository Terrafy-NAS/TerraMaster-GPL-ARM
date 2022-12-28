#
# Copyright (C) 2015-2016 Realtek
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk
include $(INCLUDE_DIR)/target.mk

PKG_NAME:=u-boot32
PKG_VERSION:=baebd9b
RELEASE_DATE:=$(shell date +%Y%m%d)
PKG_RELEASE:=1

PKG_SOURCE_PROTO:=git
PKG_SOURCE_URL:=
PKG_SOURCE_BRANCH:=master
PKG_SOURCE_VERSION:=$(PKG_VERSION)
PKG_SOURCE_SUBDIR:=$(PKG_NAME)-$(PKG_VERSION)
PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION).tar.bz2
PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_NAME)-$(PKG_VERSION)

PKG_CONFIG_DEPENDS:= \
	CONFIG_TARGET_rtd1195_nand \
	CONFIG_TARGET_rtd1195_spi \
	CONFIG_TARGET_rtd1195_emmc \
	CONFIG_TARGET_rtd1195_mnas_emmc

include $(INCLUDE_DIR)/package.mk

LOWER_BOARD_NAME=rtd1195
layout_type?=$(SUBTARGET)

#OPT:=USE_PRIVATE_LIBGCC="yes"
TARGET_CFLAGS+=

define Package/u-boot32
  SECTION:=boot
  CATEGORY:=Boot Loaders
  DEPENDS:=@TARGET_rtd1195
  TITLE:=Das U-Boot
endef

define Package/u-boot32/description
 Das U-Boot -- the Universal Boot Loader
endef

define Build/Prepare
	rm -rf $(PKG_BUILD_DIR)
	-git clean -f -d $(TOPDIR)/u-boot32
	-git checkout -- $(TOPDIR)/u-boot32
	ln -s $(TOPDIR)/u-boot32 $(PKG_BUILD_DIR)
	$(Build/Patch)
	$(CP) ./src/* $(PKG_BUILD_DIR)
endef

define Build/Configure
endef

define Build/Compile
	$(MAKE) -C $(PKG_BUILD_DIR) distclean
	$(MAKE) -C $(PKG_BUILD_DIR) mrproper
ifeq ($(layout_type),spi)
	$(MAKE) -C $(PKG_BUILD_DIR) $(LOWER_BOARD_NAME)_nas_spi_config
else ifeq ($(layout_type),nand)
	$(MAKE) -C $(PKG_BUILD_DIR) $(LOWER_BOARD_NAME)_nas_nand_config
else
	$(MAKE) -C $(PKG_BUILD_DIR) $(LOWER_BOARD_NAME)_qa_emmc_config
endif
	$(MAKE) -C $(PKG_BUILD_DIR) CROSS_COMPILE=$(TARGET_CROSS) $(OPT)
endef

define Package/u-boot32/install
	$(INSTALL_DIR) $(BIN_DIR)/$(PKG_NAME)
	$(CP) $(PKG_BUILD_DIR)/examples/flash_writer_u/*.hwsetting*.bin $(BIN_DIR)/$(PKG_NAME)/
	$(CP) $(PKG_BUILD_DIR)/examples/flash_writer_u/dvrboot.exe.bin \
	    $(BIN_DIR)/$(PKG_NAME)/NAS_$(LOWER_BOARD_NAME)_$(layout_type).bin
endef

$(eval $(call BuildPackage,u-boot32))
