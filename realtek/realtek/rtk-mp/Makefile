#
# Copyright (C) 2015-2017 Realtek
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk
include $(INCLUDE_DIR)/target.mk

PKG_NAME:=rtk-mp
PKG_RELEASE:=1

PKG_BUILD_DIR := $(BUILD_DIR)/$(PKG_NAME)
include $(INCLUDE_DIR)/package.mk

TARGET_CFLAGS += -D_GNU_SOURCE

define Package/rtk-mp
  SECTION:=base
  CATEGORY:=Base system
  TITLE:=flash burning for Realtek SoC
  DEPENDS:=@TARGET_rtd1295 @PACKAGE_u-boot64
  DEPENDS+=@RTK_BOARD_MTD_LAYOUT
endef

define Package/rtk-mp/description
 Realtek SoC MP process for OpenWRT platform
endef

SIZE_MB := 8
MP_FILE := openwrt-$(BOARD)-$(SUBTARGET)-rtk-spi-$(SIZE_MB)M-initrd-mp.bin
MP_SRC := $(subst .,_,$(subst -,_,$(MP_FILE)))
#cd $(BIN_DIR) && $(TARGET_CROSS)objcopy -I binary -O elf64-littleaarch64 -B aarch64  $(MP_FILE) $(PKG_BUILD_DIR)/mp_src.bin
define Build/Prepare
	mkdir -p $(PKG_BUILD_DIR)
	$(CP) ./src/* $(PKG_BUILD_DIR)/
	sed -i "s/MP_SRC/$(MP_SRC)/g" $(PKG_BUILD_DIR)/dvrmain.c
	cd $(BIN_DIR) && xxd -i -l $$$$(($(SIZE_MB) * 1024 * 1024)) $(MP_FILE) $(PKG_BUILD_DIR)/mp_src.c
	sed -i "s/unsigned/const unsigned/g" $(PKG_BUILD_DIR)/mp_src.c
endef

define Package/rtk-mp/install
	$(INSTALL_DIR) $(BIN_DIR)
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/mp.bin $(BIN_DIR)/$(BOARD)_$(SUBTARGET)_mp.bin
endef

$(eval $(call BuildPackage,rtk-mp))
