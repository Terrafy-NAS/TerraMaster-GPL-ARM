#
# Copyright (C) 2006-2016 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=forked-daapd
PKG_VERSION:=25.0
PKG_RELEASE:=1

PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION).tar.xz
PKG_SOURCE_URL:=https://github.com/ejurgensen/$(PKG_NAME)/releases/download/$(PKG_VERSION)/
PKG_HASH:=5741a64d8f54e11e89dfa2fbfae693b2837e1e19a0c4980a20f8ff56bce4456e

PKG_BUILD_DEPENDS:=gperf/host
PKG_FIXUP:=autoreconf
PKG_USE_MIPS16:=0
PKG_INSTALL:=1

PKG_MAINTAINER:=Espen Jürgensen <espenjurgensen+openwrt@gmail.com>
PKG_LICENSE:=GPL-2.0
PKG_LICENSE_FILES:=COPYING

include $(INCLUDE_DIR)/package.mk
include $(INCLUDE_DIR)/nls.mk

define Package/forked-daapd
SECTION:=sound
CATEGORY:=Sound
TITLE:=iTunes (DAAP) server for Apple Remote and AirPlay
URL:=https://github.com/ejurgensen/forked-daapd
DEPENDS:=+libgpg-error +libgcrypt +libgdbm +zlib +libexpat +libunistring \
	+libevent2.1 +libdaemon +libantlr3c +confuse +alsa-lib +libffmpeg-full \
	+mxml +libavahi-client +sqlite3-cli +libplist +libcurl +libjson-c \
	+libprotobuf-c +libgnutls +libsodium $(ICONV_DEPENDS) +libevent2.1-pthreads
USERID:=daapd=190:aid_inet=3003
endef

define Package/forked-daapd/description
  forked-daapd is a Linux/FreeBSD DAAP (iTunes), MPD (Music Player Daemon) and
  RSP (Roku) media server. It has support for AirPlay speakers, Chromecast,
  Apple Remote (and compatibles), MPD clients, internet radio and LastFM. It
  does not support AirPlay/Chromecast video.
endef

define Package/forked-daapd/conffiles
/etc/forked-daapd.conf
endef

CONFIGURE_ARGS += \
	--enable-itunes \
	--enable-lastfm \
	--enable-mpd \
	LIBEVENT_LIBS="-L$(STAGING_DIR)/usr/lib/libevent2.1 -l:libevent-2.1.so.5" \
	LIBEVENT_CFLAGS="-I$(STAGING_DIR)/usr/include/libevent2.1" \
	LIBEVENT_PTHREADS_LIBS="-L$(STAGING_DIR)/usr/lib/libevent2.1/ -l:libevent_pthreads-2.1.so.5 -l:libevent-2.1.so.5" \
	LIBEVENT_PTHREADS_CFLAGS="-pthread -I$(STAGING_DIR)/usr/include/libevent2.1" \


TARGET_CFLAGS += $(FPIC) -I$(STAGING_DIR)/usr/include/libevent2.1
TARGET_LDFLAGS += -Wl,-rpath-link,$(STAGING_DIR)/usr/lib -Wl,-rpath,/usr/lib/libevent2.1

define Package/forked-daapd/install
	$(INSTALL_DIR) $(1)/usr/sbin
	$(INSTALL_BIN) $(PKG_INSTALL_DIR)/usr/sbin/forked-daapd $(1)/usr/sbin/
	$(INSTALL_DIR) $(1)/etc
	$(INSTALL_CONF) ./files/forked-daapd.conf $(1)/etc/forked-daapd.conf
	$(INSTALL_DIR) $(1)/etc/config
	$(INSTALL_CONF) ./files/forked-daapd.config $(1)/etc/config/forked-daapd
	$(INSTALL_DIR) $(1)/usr/lib/forked-daapd
	$(INSTALL_BIN) $(PKG_INSTALL_DIR)/usr/lib/forked-daapd/* $(1)/usr/lib/forked-daapd/
	$(INSTALL_DIR) $(1)/etc/init.d
	$(INSTALL_BIN) ./files/forked-daapd.init $(1)/etc/init.d/forked-daapd
	$(INSTALL_DIR) $(1)/etc/hotplug.d/block
	$(INSTALL_CONF) ./files/hotplug.sh $(1)/etc/hotplug.d/block/20-forked-daapd-hotplug
endef

$(eval $(call BuildPackage,forked-daapd))
