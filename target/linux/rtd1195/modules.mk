#
# Copyright (C) 2012 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#
define KernelPackage/rtl8152-rtd1195
  SUBMENU:=$(USB_MENU)
  TITLE:=Realtek RTL8152 USB driver
  KCONFIG:=CONFIG_USB_RTL8152
  FILES:=$(LINUX_DIR)/drivers/net/usb/r8152.ko
  AUTOLOAD:=$(call AutoLoad,18,r8152)
  DEPENDS:=@TARGET_rtd1195
endef

define KernelPackage/rtl8152-rtd1195/description
  This package contains the Realtek 8152 USB NIC driver
endef

$(eval $(call KernelPackage,rtl8152-rtd1195))

define KernelPackage/usb-uas-rtd1195
  SUBMENU:=$(USB_MENU)
  TITLE:=USB UAS support from kernel 4.1-rc2
  KCONFIG:=CONFIG_USB_UAS
  FILES:=$(LINUX_DIR)/drivers/usb/storage/uas.ko
  AUTOLOAD:=$(call AutoLoad,25,uas)
  DEPENDS:=@TARGET_rtd1195
endef

define KernelPackage/usb-uas-rtd1195/description
  This package contains the USB UAS driver backported from kernel 4.1-rc2
endef

$(eval $(call KernelPackage,usb-uas-rtd1195))
