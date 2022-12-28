#
# Copyright (C) 2012-2013 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#
include $(TOPDIR)/rules.mk
include $(INCLUDE_DIR)/host.mk

ARCH:=aarch64
BOARD:=rtd1295
BOARDNAME:=Realtek RTD1295
FEATURES:=
CFLAGS:=-Os -pipe -fno-caller-saves
MAINTAINER:=phinexhung <phinexhung@realtek.com>
CPU_TYPE:=cortex-a53
CPU_SUBTYPE:=neon
SUBTARGETS:=nas_emmc mnas_emmc gmnas_emmc nas_spi nas_nand

#KERNEL_PATCHVER:=4.1
KERNEL_PATCHVER:=4.4
LINARO_KERNEL:=n

include $(INCLUDE_DIR)/target.mk
DEFAULT_PACKAGES +=

KERNELNAME:=Image dtbs
USE_LOCALVERSION:=1

$(eval $(call BuildTarget))
