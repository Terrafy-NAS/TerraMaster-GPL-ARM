
PKG_DRIVERS += rtkwifiu

PKG_RTKWIFIU_NAME:=rtkwifiu
PKG_RTKWIFIU_VERSION:=b644fe6
PKG_RTKWIFIU_SOURCE:=$(PKG_RTKWIFIU_NAME)-$(PKG_RTKWIFIU_VERSION).tar.bz2
PKG_RTKWIFIU_SOURCE_URL:=@DHCGERRIT/phoenix/drivers/wifi
PKG_RTKWIFIU_SUBDIR:=$(PKG_RTKWIFIU_NAME)

ifneq ($(CONFIG_PACKAGE_kmod-rtkwifiu),)
RTKWIFIU_DIR := $(PKG_BUILD_DIR)/drivers/net/wireless/realtek/rtkwifiu
RTKWIFIU_PKG := rtkwifiu-rtl8188eu rtkwifiu-rtl8188fu rtkwifiu-rtl8189es rtkwifiu-rtl8189fs rtkwifiu-rtl8723bs \
		rtkwifiu-rtl8811au rtkwifiu-rtl8821au rtkwifiu-rtl8821cu rtkwifiu-rtl8821as rtkwifiu-rtl8821cs \
		rtkwifiu-rtl8812au rtkwifiu-rtl8812bu rtkwifiu-rtl8812ae rtkwifiu-rtl8192ee rtkwifiu-rtl8192cux rtkwifiu-rtl8192eu \
		rtkwifiu-rtl8723bu rtkwifiu-rtl8723du rtkwifiu-rtl8822be rtkwifiu-rtl8822bu rtkwifiu-rtl8822bs rtkwifiu-rtl8814au
PKG_DRIVERS += $(RTKWIFIU_PKG)
BACKPORT_VER_FILES := os_dep/linux/ioctl_cfg80211.h os_dep/linux/ioctl_cfg80211.c os_dep/linux/rtw_cfgvendor.h \
		os_dep/linux/rtw_cfgvendor.c os_dep/linux/wifi_regd.c core/rtw_ap.c
RESOTRE_LINUX_API_FILES := os_dep/linux/ioctl_cfg80211.c
endif

define Download/rtkwifiu
  PROTO:=git
  VERSION:=$(PKG_RTKWIFIU_VERSION)
  SUBDIR:=$(PKG_RTKWIFIU_SUBDIR)
  FILE:=$(PKG_RTKWIFIU_SOURCE)
  URL:=$(PKG_RTKWIFIU_SOURCE_URL)
endef
$(eval $(call Download,rtkwifiu))

define KernelPackage/rtkwifiu/Default
  VERSION:=$(PKG_RTKWIFIU_VERSION)
  TITLE:=Realtek Compat Wifi Drivers
  SUBMENU:=$(WMENU)
  DEPENDS+= @(PCI_SUPPORT||USB_SUPPORT) +kmod-cfg80211 +@DRIVER_11N_SUPPORT
endef

define KernelPackage/rtkwifiu
  $(call KernelPackage/rtkwifiu/Default)
  MENU:=1
endef

define KernelPackage/rtkwifiu/config
  if PACKAGE_kmod-rtkwifiu
        config RTKWIFIU
		default y
		 bool

        config RTKWIFIU_CONCURRENT_MODE
		bool "Enable CONFIG_CONCURRENT_MODE"
		depends on RTKWIFIU
		default y
		help
		Select this to enable CONFIG_CONCURRENT_MODE.
  endif
endef

define KernelPackage/rtkwifiu-rtl8188eu
  $(call KernelPackage/rtkwifiu/Default)
  DEPENDS+=@USB_SUPPORT @PACKAGE_kmod-rtkwifiu
  TITLE+= (RTL8188E USB)
  FILES:=$(RTKWIFIU_DIR)/rtl8188eu/8188eu.ko
  AUTOLOAD:=$(call AutoProbe,8188eu)
endef

define KernelPackage/rtkwifiu-rtl8188fu
  $(call KernelPackage/rtkwifiu/Default)
  DEPENDS+= @USB_SUPPORT @PACKAGE_kmod-rtkwifiu
  TITLE+= (RTL8188F USB)
  FILES:=$(RTKWIFIU_DIR)/rtl8188fu/8188fu.ko
  AUTOLOAD:=$(call AutoProbe,8188fu)
endef

define KernelPackage/rtkwifiu-rtl8189es
  $(call KernelPackage/rtkwifiu/Default)
  DEPENDS+= @PACKAGE_kmod-rtkwifiu
  TITLE+= (RTL8189E SDIO)
  FILES:=$(RTKWIFIU_DIR)/rtl8189es/8189es.ko
  AUTOLOAD:=$(call AutoProbe,8189es)
endef

define KernelPackage/rtkwifiu-rtl8189fs
  $(call KernelPackage/rtkwifiu/Default)
  DEPENDS+= @PACKAGE_kmod-rtkwifiu
  TITLE+= (RTL8189F SDIO)
  FILES:=$(RTKWIFIU_DIR)/rtl8189fs/8189fs.ko
  AUTOLOAD:=$(call AutoProbe,8189fs)
endef

define KernelPackage/rtkwifiu-rtl8192cux
  $(call KernelPackage/rtkwifiu/Default)
  DEPENDS+= @USB_SUPPORT @PACKAGE_kmod-rtkwifiu
  TITLE+= (RTL8192C USB)
  FILES:=$(RTKWIFIU_DIR)/rtl8192cu/8192cu.ko
  AUTOLOAD:=$(call AutoProbe,8192cu)
endef

define KernelPackage/rtkwifiu-rtl8192eu
  $(call KernelPackage/rtkwifiu/Default)
  DEPENDS+= @USB_SUPPORT @PACKAGE_kmod-rtkwifiu
  TITLE+= (RTL8192E USB)
  FILES:=$(RTKWIFIU_DIR)/rtl8192eu/8192eu.ko
  AUTOLOAD:=$(call AutoProbe,8192eu)
endef

define KernelPackage/rtkwifiu-rtl8723bs
  $(call KernelPackage/rtkwifiu/Default)
  DEPENDS+= @PACKAGE_kmod-rtkwifiu
  TITLE+= (RTL8723B SDIO)
  FILES:=$(RTKWIFIU_DIR)/rtl8723bs/8723bs.ko
  AUTOLOAD:=$(call AutoProbe,8723bs)
endef

define KernelPackage/rtkwifiu-rtl8723bu
  $(call KernelPackage/rtkwifiu/Default)
  DEPENDS+= @USB_SUPPORT @PACKAGE_kmod-rtkwifiu
  TITLE+= (RTL8723B USB)
  FILES:=$(RTKWIFIU_DIR)/rtl8723bu/8723bu.ko
  AUTOLOAD:=$(call AutoProbe,8723bu)
endef

define KernelPackage/rtkwifiu-rtl8723du
  $(call KernelPackage/rtkwifiu/Default)
  DEPENDS+= @USB_SUPPORT @PACKAGE_kmod-rtkwifiu
  TITLE+= (RTL8723D USB)
  FILES:=$(RTKWIFIU_DIR)/rtl8723du/8723du.ko
  AUTOLOAD:=$(call AutoProbe,8723du)
endef

define KernelPackage/rtkwifiu-rtl8811au
  $(call KernelPackage/rtkwifiu/Default)
  DEPENDS+= @USB_SUPPORT @PACKAGE_kmod-rtkwifiu @!PACKAGE_kmod-rtkwifiu-rtl8821au
  TITLE+= (RTL8811A USB)
  FILES:=$(RTKWIFIU_DIR)/rtl8811au/8811au.ko
  AUTOLOAD:=$(call AutoProbe,8811au)
endef

define KernelPackage/rtkwifiu-rtl8821au
  $(call KernelPackage/rtkwifiu/Default)
  DEPENDS+= @USB_SUPPORT @PACKAGE_kmod-rtkwifiu
  TITLE+= (RTL8821A USB)
  FILES:=$(RTKWIFIU_DIR)/rtl8821au/8821au.ko
  AUTOLOAD:=$(call AutoProbe,8821au)
endef

define KernelPackage/rtkwifiu-rtl8821cu
  $(call KernelPackage/rtkwifiu/Default)
  DEPENDS+= @USB_SUPPORT @PACKAGE_kmod-rtkwifiu
  TITLE+= (RTL8821C USB)
  FILES:=$(RTKWIFIU_DIR)/rtl8821cu/8821cu.ko
  AUTOLOAD:=$(call AutoProbe,8821cu)
endef

define KernelPackage/rtkwifiu-rtl8822bu
  $(call KernelPackage/rtkwifiu/Default)
  DEPENDS+= @USB_SUPPORT @PACKAGE_kmod-rtkwifiu
  TITLE+= (RTL8822B USB)
  FILES:=$(RTKWIFIU_DIR)/rtl8822bu/8822bu.ko
  AUTOLOAD:=$(call AutoProbe,8822bu)
endef

define KernelPackage/rtkwifiu-rtl8822be
  $(call KernelPackage/rtkwifiu/Default)
  DEPENDS+= @PCI_SUPPORT @PACKAGE_kmod-rtkwifiu
  TITLE+= (RTL8822B PCIe)
  FILES:=$(RTKWIFIU_DIR)/rtl8822be/8822be.ko
  AUTOLOAD:=$(call AutoProbe,8822be)
endef

define KernelPackage/rtkwifiu-rtl8822bs
  $(call KernelPackage/rtkwifiu/Default)
  DEPENDS+= @PACKAGE_kmod-rtkwifiu
  TITLE+= (RTL8822B SDIO)
  FILES:=$(RTKWIFIU_DIR)/rtl8822bs/8822bs.ko
  AUTOLOAD:=$(call AutoProbe,8822bs)
endef

define KernelPackage/rtkwifiu-rtl8812au
  $(call KernelPackage/rtkwifiu/Default)
  DEPENDS+= @USB_SUPPORT @PACKAGE_kmod-rtkwifiu
  TITLE+= (RTL8812A USB)
  FILES:=$(RTKWIFIU_DIR)/rtl8812au/8812au.ko
  AUTOLOAD:=$(call AutoProbe,8812au)
endef

define KernelPackage/rtkwifiu-rtl8812bu
  $(call KernelPackage/rtkwifiu/Default)
  DEPENDS+= @USB_SUPPORT @PACKAGE_kmod-rtkwifiu
  TITLE+= (RTL8812B USB)
  FILES:=$(RTKWIFIU_DIR)/rtl8812bu/8812bu.ko
  AUTOLOAD:=$(call AutoProbe,8812bu)
endef

define KernelPackage/rtkwifiu-rtl8814au
  $(call KernelPackage/rtkwifiu/Default)
  DEPENDS+= @USB_SUPPORT @PACKAGE_kmod-rtkwifiu
  TITLE+= (RTL8814A USB)
  FILES:=$(RTKWIFIU_DIR)/rtl8814au/8814au.ko
  AUTOLOAD:=$(call AutoProbe,8814au)
endef

define KernelPackage/rtkwifiu-rtl8821as
  $(call KernelPackage/rtkwifiu/Default)
  DEPENDS+= @PACKAGE_kmod-rtkwifiu
  TITLE+= (RTL8821A SDIO)
  FILES:=$(RTKWIFIU_DIR)/rtl8821as/8821as.ko
  AUTOLOAD:=$(call AutoProbe,8821as)
endef

define KernelPackage/rtkwifiu-rtl8821cs
  $(call KernelPackage/rtkwifiu/Default)
  DEPENDS+= @PACKAGE_kmod-rtkwifiu
  TITLE+= (RTL8821C SDIO)
  FILES:=$(RTKWIFIU_DIR)/rtl8821cs/8821cs.ko
  AUTOLOAD:=$(call AutoProbe,8821cs)
endef

define KernelPackage/rtkwifiu-rtl8812ae
  $(call KernelPackage/rtkwifiu/Default)
  DEPENDS+= @PCI_SUPPORT @PACKAGE_kmod-rtkwifiu
  TITLE+= (RTL8812A PCIe)
  FILES:=$(RTKWIFIU_DIR)/rtl8812ae/8812ae.ko
  AUTOLOAD:=$(call AutoProbe,8812ae)
endef

define KernelPackage/rtkwifiu-rtl8192ee
  $(call KernelPackage/rtkwifiu/Default)
  DEPENDS+= @PCI_SUPPORT @PACKAGE_kmod-rtkwifiu
  TITLE+= (RTL8192E PCIe)
  FILES:=$(RTKWIFIU_DIR)/rtl8192ee/8192ee.ko
  AUTOLOAD:=$(call AutoProbe,8192ee)
endef

config-$(call config_package,rtkwifiu) += RTKWIFIU
config-$(call config_package,rtkwifiu-rtl8188eu) += RTL8188EU
config-$(call config_package,rtkwifiu-rtl8188fu) += RTL8188FU
config-$(call config_package,rtkwifiu-rtl8189es) += RTL8189ES
config-$(call config_package,rtkwifiu-rtl8189fs) += RTL8189FS
config-$(call config_package,rtkwifiu-rtl8192cux) += RTL8192CU
config-$(call config_package,rtkwifiu-rtl8192eu) += RTL8192EU
config-$(call config_package,rtkwifiu-rtl8723bs) += RTL8723BS
config-$(call config_package,rtkwifiu-rtl8723bu) += RTL8723BU
config-$(call config_package,rtkwifiu-rtl8723du) += RTL8723DU
config-$(call config_package,rtkwifiu-rtl8811au) += RTL8811AU
config-$(call config_package,rtkwifiu-rtl8821au) += RTL8821AU
config-$(call config_package,rtkwifiu-rtl8821cu) += RTL8821CU
config-$(call config_package,rtkwifiu-rtl8822bu) += RTL8822BU
config-$(call config_package,rtkwifiu-rtl8822be) += RTL8822BE
config-$(call config_package,rtkwifiu-rtl8822bs) += RTL8822BS
config-$(call config_package,rtkwifiu-rtl8812au) += RTL8812AU
config-$(call config_package,rtkwifiu-rtl8812bu) += RTL8812BU
config-$(call config_package,rtkwifiu-rtl8814au) += RTL8814AU
config-$(call config_package,rtkwifiu-rtl8821as) += RTL8821AS
config-$(call config_package,rtkwifiu-rtl8821cs) += RTL8821CS
config-$(call config_package,rtkwifiu-rtl8812ae) += RTL8812AE
config-$(call config_package,rtkwifiu-rtl8192ee) += RTL8192EE

ifneq ($(CONFIG_PACKAGE_kmod-rtkwifiu),)
RTKWIFIU_OPTS+=CONFIG_PLATFORM_RTL8117=$(CONFIG_TARGET_rtl8117)
RTKWIFIU_OPTS+=CONFIG_PLATFORM_RTK119X=$(CONFIG_TARGET_rtd1195)
RTKWIFIU_OPTS+=CONFIG_PLATFORM_RTK129X=$(CONFIG_TARGET_rtd1295)
RTKWIFIU_OPTS+=CONFIG_PLATFORM_RTK139X=$(CONFIG_TARGET_rtd1395)
RTKWIFIU_OPTS+=TopDIR=$(RTKWIFIU_DIR)
##backport kernel 4.14
##expr $((4<<16)) + $((14<<8))
BACKPORT_VERSION_CODE:=265728
RTKWIFIU_OPTS+=USER_EXTRA_CFLAGS="-DBUILD_OPENWRT -Wno-error=date-time -DCONFIG_RTW_HOSTAPD_ACS -DBACKPORT_VERSION_CODE=$(BACKPORT_VERSION_CODE)"
endif

$(eval $(call KernelPackage,rtkwifiu))
$(eval $(call KernelPackage,rtkwifiu-rtl8188eu))
$(eval $(call KernelPackage,rtkwifiu-rtl8188fu))
$(eval $(call KernelPackage,rtkwifiu-rtl8189es))
$(eval $(call KernelPackage,rtkwifiu-rtl8189fs))
$(eval $(call KernelPackage,rtkwifiu-rtl8192cux))
$(eval $(call KernelPackage,rtkwifiu-rtl8192eu))
$(eval $(call KernelPackage,rtkwifiu-rtl8723bs))
$(eval $(call KernelPackage,rtkwifiu-rtl8723bu))
$(eval $(call KernelPackage,rtkwifiu-rtl8723du))
$(eval $(call KernelPackage,rtkwifiu-rtl8811au))
$(eval $(call KernelPackage,rtkwifiu-rtl8821au))
$(eval $(call KernelPackage,rtkwifiu-rtl8821cu))
$(eval $(call KernelPackage,rtkwifiu-rtl8822bu))
$(eval $(call KernelPackage,rtkwifiu-rtl8822be))
$(eval $(call KernelPackage,rtkwifiu-rtl8822bs))
$(eval $(call KernelPackage,rtkwifiu-rtl8812au))
$(eval $(call KernelPackage,rtkwifiu-rtl8812bu))
$(eval $(call KernelPackage,rtkwifiu-rtl8814au))
$(eval $(call KernelPackage,rtkwifiu-rtl8821as))
$(eval $(call KernelPackage,rtkwifiu-rtl8821cs))
$(eval $(call KernelPackage,rtkwifiu-rtl8812ae))
$(eval $(call KernelPackage,rtkwifiu-rtl8192ee))
