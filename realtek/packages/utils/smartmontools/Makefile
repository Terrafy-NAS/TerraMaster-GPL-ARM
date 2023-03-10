#
# Copyright (C) 2006-2016 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk
include $(INCLUDE_DIR)/uclibc++.mk

PKG_NAME:=smartmontools
PKG_VERSION:=6.6
PKG_RELEASE:=1

PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION).tar.gz
PKG_SOURCE_URL:=@SF/smartmontools
PKG_HASH:=51f43d0fb064fccaf823bbe68cf0d317d0895ff895aa353b3339a3b316a53054
PKG_MAINTAINER:=Maxim Storchak <m.storchak@gmail.com>
PKG_LICENSE:=GPL-2.0+
PKG_LICENSE_FILES:=COPYING

PKG_FIXUP:=autoreconf

include $(INCLUDE_DIR)/package.mk

define Package/smartmontools/Default
  SECTION:=utils
  CATEGORY:=Utilities
  DEPENDS:=$(CXX_DEPENDS)
  TITLE:=S.M.A.R.T Monitoring
  URL:=http://smartmontools.sourceforge.net/
endef

define Package/smartmontools
  $(call Package/smartmontools/Default)
  TITLE+= Tool
endef

define Package/smartmontools/description
  smartmontools contains utility programs (smartctl) to
  control/monitor storage systems using the Self-Monitoring, Analysis
  and Reporting Technology System (S.M.A.R.T.) built into most modern
  ATA and SCSI disks. It is derived from smartsuite.
endef

define Package/smartd
  $(call Package/smartmontools/Default)
  TITLE+= Daemon
endef

define Package/smartd/description
  smartmontools contains utility programs (smartd) to
  control/monitor storage systems using the Self-Monitoring, Analysis
  and Reporting Technology System (S.M.A.R.T.) built into most modern
  ATA and SCSI disks. It is derived from smartsuite.
endef

ifeq ($(CONFIG_USE_UCLIBC),y)
  EXTRA_CPPFLAGS+=-I$(STAGING_DIR)/usr/include/uClibc++ -I$(LINUX_DIR)/include
  EXTRA_LDFLAGS+=-luClibc++
else
  TARGET_CROSS_NAME:=$(patsubst %-,%,$(TARGET_CROSS))
  GLIBC_INCLUDE:=-I$(TOOLCHAIN_DIR)/include -I$(TOOLCHAIN_DIR)/$(TARGET_CROSS_NAME)/include/c++/$(GCC_PKG_VERSION)
  GLIBC_INCLUDE:=$(GLIBC_INCLUDE) $(GLIBC_INCLUDE)/$(TARGET_CROSS_NAME)

  EXTRA_CPPFLAGS+=$(GLIBC_INCLUDE)
  EXTRA_LDFLAGS+=-lstdc++
endif

CONFIGURE_VARS += \
	CXXFLAGS="$$$$CXXFLAGS $(UCXXCFLAGS)" \
	CPPFLAGS="$$$$CPPFLAGS $(UCXXCPPFLAGS) -I$(LINUX_DIR)/include" \
	LDFLAGS="$$$$LDFLAGS" \
	LIBS="$(UCXXLIBS) -lm $(LIBGCC_S) -lc" \

define Build/Compile
	$(MAKE) -C $(PKG_BUILD_DIR) \
		BUILD_INFO='"(localbuild)"' \
		LD="$(TARGET_CXX)"
endef

define Package/smartmontools/install
	$(INSTALL_DIR) $(1)/usr/sbin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/smartctl $(1)/usr/sbin/
endef

define Package/smartd/install
	$(INSTALL_DIR) $(1)/usr/sbin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/smartd $(1)/usr/sbin/
	$(INSTALL_DIR) $(1)/etc
	$(INSTALL_DATA) ./files/smartd.conf $(1)/etc/
	$(INSTALL_DIR) $(1)/etc/init.d
	$(INSTALL_BIN) ./files/smartd.init $(1)/etc/init.d/smartd
endef

define Package/smartd/conffiles
/etc/smartd.conf
endef

$(eval $(call BuildPackage,smartmontools))
$(eval $(call BuildPackage,smartd))
