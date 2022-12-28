include $(TOPDIR)/rules.mk

PKG_NAME:=netifaces
PKG_VERSION:=0.10.0
PKG_RELEASE:=1

PKG_SOURCE:=release_0_10_0.tar.gz
PKG_SOURCE_URL:=https://bitbucket.org/al45tair/netifaces/get/

PKG_BUILD_DIR:=$(BUILD_DIR)/al45tair-netifaces-6030c12264f1
PKG_BUILD_DEPENDS:=python

include $(INCLUDE_DIR)/package.mk
$(call include_mk, python-package.mk)

define Package/python-netifaces
  SUBMENU:=Python
  SECTION:=lang
  CATEGORY:=Languages
  TITLE:=python-netifaces
  URL:=https://bitbucket.org/al45tair/netifaces
  DEPENDS:=+python
endef

define Package/python-netifaces/description
  netifaces can get the address(es) of the machine's network interfaces from Python.
endef

define Build/Compile
	$(call Build/Compile/PyMod,., \
		install --prefix="/usr" --root="$(PKG_INSTALL_DIR)" \
	)
endef

define Package/python-netifaces/install
	$(INSTALL_DIR) $(1)$(PYTHON_PKG_DIR)
	$(CP) \
		$(PKG_INSTALL_DIR)$(PYTHON_PKG_DIR)/* \
		$(1)$(PYTHON_PKG_DIR)/
endef

$(eval $(call BuildPackage,python-netifaces))
