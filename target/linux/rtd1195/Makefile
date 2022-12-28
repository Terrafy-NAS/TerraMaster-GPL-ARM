#
# Copyright (C) 2012-2013 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#
include $(TOPDIR)/rules.mk
include $(INCLUDE_DIR)/host.mk

ARCH:=arm
BOARD:=rtd1195
BOARDNAME:=Realtek RTD1195
FEATURES:=
MAINTAINER:=phinexhung <phinexhung@realtek.com>
CPU_TYPE:=cortex-a7
CPU_SUBTYPE:=neon
SUBTARGETS:=nand emmc spi mnas_emmc

KERNEL_PATCHVER:=4.4
LINARO_KERNEL:=n

include $(INCLUDE_DIR)/target.mk
DEFAULT_PACKAGES +=


KERNELNAME:=uImage dtbs
USE_LOCALVERSION:=1

$(eval $(call BuildTarget))
