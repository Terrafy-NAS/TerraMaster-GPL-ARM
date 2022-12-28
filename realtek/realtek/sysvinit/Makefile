#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=sysvinit
PKG_VERSION:=2.88
PKG_RELEASE:=1

PKG_SOURCE:=sysvinit-$(PKG_VERSION)dsf.tar.bz2
PKG_SOURCE_URL:=http://download.savannah.gnu.org/releases/sysvinit/
PKG_MD5SUM:=6eda8a97b86e0a6f59dabbf25202aa6f
PKG_CAT:=bzcat

PKG_BUILD_DIR:=$(BUILD_DIR)/sysvinit-$(PKG_VERSION)dsf

include $(INCLUDE_DIR)/package.mk

define Package/sysvinit
	SECTION:=utils
	CATEGORY:=Utilities
	DEFAULT:=y
	TITLE:=System V style Init
	URL:=http://savannah.nongnu.org/projects/sysvinit
endef

define Package/sysvinit/description
	System V style init programs
endef

define Build/Compile
	+$(MAKE) $(PKG_JOBS) -C $(PKG_BUILD_DIR)/src CC="$(TARGET_CROSS)"gcc "SULOGINLIBS+=-lcrypt"
endef

define Package/sysvinit/install
	$(INSTALL_DIR) $(1)/usr/bin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/src/last $(1)/usr/bin
	$(INSTALL_DIR) $(1)/sbin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/src/killall5 $(1)/sbin/pidof
endef

$(eval $(call BuildPackage,sysvinit))
