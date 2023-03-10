#
# Copyright (C) 2006-2012 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=kexec-tools
PKG_VERSION:=2.0.14
PKG_RELEASE:=1

PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION).tar.xz
PKG_SOURCE_URL:=@KERNEL/linux/utils/kernel/kexec
PKG_MD5SUM:=4164abff8ed21e9f94d57f535c2f77bf

PKG_FIXUP:=autoreconf

PKG_CONFIG_DEPENDS := CONFIG_KEXEC_ZLIB CONFIG_KEXEC_LZMA

include $(INCLUDE_DIR)/package.mk

define Package/kexec-tools
  SECTION:=utils
  CATEGORY:=Utilities
  DEPENDS:=+@KERNEL_KEXEC @armeb||@arm||@aarch64||@i386||@powerpc64||@mipsel||@mips +KEXEC_ZLIB:zlib +KEXEC_LZMA:liblzma
  DEPENDS+= +@KERNEL_KALLSYMS
  TITLE:=Kernel boots kernel
  URL:=http://kernel.org/pub/linux/kernel/people/horms/kexec-tools/
  MAINTAINER:=Florian Fainelli <florian@openwrt.org>
  MENU:=1
  KCONFIG:= \
	CONFIG_CRASH_DUMP=y \
	CONFIG_KALLSYMS_ALL=y \
	CONFIG_PROC_VMCORE=y
endef

define Package/kexec-tools/description
 kexec is a set of systems call that allows you to load
 another kernel from the currently executing Linux kernel.
endef

define Package/kexec-tools/config
	source "$(SOURCE)/Config.in"
endef

KEXEC_TARGET_NAME:=$(call qstrip,$(CONFIG_KEXEC_TOOLS_TARGET_NAME))-linux-$(TARGET_SUFFIX)

CONFIGURE_ARGS = \
		--target=$(KEXEC_TARGET_NAME) \
		--host=$(REAL_GNU_TARGET_NAME) \
		--build=$(GNU_HOST_NAME) \
		--program-prefix="" \
		--program-suffix="" \
		--prefix=/usr \
		--exec-prefix=/usr \
		--bindir=/usr/bin \
		--sbindir=/usr/sbin \
		--libexecdir=/usr/lib \
		--sysconfdir=/etc \
		$(if $(CONFIG_KEXEC_ZLIB),--with,--without)-zlib \
		$(if $(CONFIG_KEXEC_LZMA),--with,--without)-lzma

TARGET_CFLAGS += -ffunction-sections -fdata-sections
TARGET_LDFLAGS += -Wl,--gc-sections

CONFIGURE_VARS += \
	BUILD_CC="$(HOSTCC)" \
	TARGET_CC="$(TARGET_CC)"

kexec-extra-sbin-$(CONFIG_KEXEC_TOOLS_kdump) += kdump
kexec-extra-sbin-y += vmcore-dmesg

define Build/Compile
	$(MAKE) -C $(PKG_BUILD_DIR) DESTDIR="$(PKG_INSTALL_DIR)" all install
endef

define Package/kexec-tools/install
	$(INSTALL_DIR) $(1)/usr/sbin
	$(INSTALL_BIN) \
		$(addprefix $(PKG_INSTALL_DIR)/usr/sbin/, \
			$(kexec-extra-sbin-y)) \
		$(kexec-extra-bin-y) \
		$(PKG_INSTALL_DIR)/usr/sbin/kexec \
		$(1)/usr/sbin

# make a link for compatability with other distros
	$(INSTALL_DIR) $(1)/sbin
	$(LN) ../usr/sbin/kexec $(1)/sbin/kexec
endef

$(eval $(call BuildPackage,kexec-tools))
