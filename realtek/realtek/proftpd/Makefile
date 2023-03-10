#
# Copyright (C) 2009-2014 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=proftpd
PKG_VERSION:=1.3.5a
PKG_RELEASE:=1

PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION).tar.gz
PKG_SOURCE_URL:=ftp://ftp.proftpd.org/distrib/source
PKG_MD5SUM:=b9d3092411478415b31d435f8e26d173

PKG_FIXUP:=autoreconf
PKG_INSTALL:=1

include $(INCLUDE_DIR)/package.mk

define Package/proftpd
  SUBMENU:=File Transfer
  SECTION:=net
  CATEGORY:=Network
  TITLE:=ProFTPD FTP server
  URL:=http://www.proftpd.org/
  MAINTAINER:=Cezary Jackiewicz <cezary@eko.one.pl>
  DEPENDS:= +libpam
endef

define Package/proftpd/conffiles
/etc/proftpd.conf
endef

TARGET_CPPFLAGS += \
	-I$(LINUX_DIR)/include

MAKE_FLAGS += \
	INSTALL_USER=$(shell id -u) \
	INSTALL_GROUP=$(shell id -g)

CONFIGURE_ARGS += \
	--disable-cap \
	--enable-devel \
	--enable-auth-pam \
	ac_cv_header_curses_h=no \
	ac_cv_header_ncurses_h=no

define Package/proftpd/install
	$(INSTALL_DIR) $(1)/etc
	$(if $(CONFIG_IPV6),,$(SED) 's/^UseIPv6/#UseIPv6/' $(PKG_INSTALL_DIR)/etc/proftpd.conf)
	$(INSTALL_DIR) $(1)/etc/proftpd
	$(INSTALL_CONF) $(PKG_INSTALL_DIR)/etc/proftpd.conf $(1)/etc/proftpd/
	$(INSTALL_DIR) $(1)/etc/init.d
	$(INSTALL_BIN) ./files/proftpd.init $(1)/etc/init.d/proftpd
	$(INSTALL_DIR) $(1)/etc $(1)/etc/pam.d
	$(INSTALL_CONF) ./files/proftpd.pam $(1)/etc/pam.d/proftpd
	$(INSTALL_CONF) ./files/ftpusers $(1)/etc/
	$(INSTALL_DIR) $(1)/usr/bin
	$(INSTALL_BIN) $(PKG_INSTALL_DIR)/usr/bin/ftp{count,top,who} $(1)/usr/bin/
	$(INSTALL_DIR) $(1)/usr/sbin
	$(INSTALL_BIN) $(PKG_INSTALL_DIR)/usr/sbin/{ftpshut,proftpd} $(1)/usr/sbin/
	$(CP) $(PKG_INSTALL_DIR)/usr/sbin/in.proftpd $(1)/usr/sbin/
endef

$(eval $(call BuildPackage,proftpd))
