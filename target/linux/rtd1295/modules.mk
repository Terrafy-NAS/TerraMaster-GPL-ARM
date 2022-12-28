#
# Copyright (C) 2012 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#


define KernelPackage/rtksdmmc
  SUBMENU:=$(RTK_MENU)
  TITLE:=Realtek SD/MMC host driver
  KCONFIG:=CONFIG_MMC_RTK_SDMMC
  FILES:=$(LINUX_DIR)/drivers/mmc/host/rtk-sdmmc.ko
  AUTOLOAD:=$(call AutoLoad,30,rtk-sdmmc)
  DEPENDS:=@TARGET_rtd1295
endef

define KernelPackage/rtksdmmc/description
  This package contains the Realtek SD/MMC host driver
endef

$(eval $(call KernelPackage,rtksdmmc))

define KernelPackage/rtksdhci
  SUBMENU:=$(OTHER_MENU)
  TITLE:=Realtek Secure Digital Host Controller Interface driver
  KCONFIG:=CONFIG_MMC_SDHCI_RTK
  FILES:=$(LINUX_DIR)/drivers/mmc/host/sdhci-rtk.ko
  AUTOLOAD:=$(call AutoProbe,sdhci-rtk)
  DEPENDS:=@TARGET_rtd1295 +kmod-mmc +kmod-sdhci
endef

define KernelPackage/rtksdhci/description
  This package contains the Realtek SDHCI host driver
endef

$(eval $(call KernelPackage,rtksdhci))


define KernelPackage/rtl815x
  SUBMENU:=$(USB_MENU)
  TITLE:=Realtek RTL8152/RTL8153 USB driver
  KCONFIG:=CONFIG_USB_RTL8152 
  FILES:= \
	$(LINUX_DIR)/drivers/net/usb/r8152.ko \
	$(LINUX_DIR)/drivers/net/mii.ko
  AUTOLOAD:=$(call AutoLoad,25,r8152)
  DEPENDS:=@TARGET_rtd1295
endef

define KernelPackage/rtl815x/description
  This package contains the Realtek 8152/8153 USB NIC driver
endef

$(eval $(call KernelPackage,rtl815x))

define KernelPackage/rtl8169soc
  SUBMENU:=$(NETWORK_DEVICES_MENU)
  TITLE:=Realtek Gigabit Ethernet driver
  KCONFIG:= \
	CONFIG_R8169SOC=y \
	CONFIG_NET_VENDOR_REALTEK=y
  FILES:=
  AUTOLOAD:=
  DEPENDS:=@TARGET_rtd1295
endef

define KernelPackage/rtl8169soc/config
	depends on !PACKAGE_kmod-rtd1295hwnat
endef

$(eval $(call KernelPackage,rtl8169soc))

define KernelPackage/rtl8168/description
  This package contains the Realtek R8168 PCI-E Gigibit Ethernet driver
endef

define KernelPackage/rtl8168
  SUBMENU:=$(NETWORK_DEVICES_MENU)
  TITLE:=Realtek R8168 PCI-E Gigabit Ethernet driver
  DEPENDS:=@TARGET_rtd1295 @PCI_SUPPORT +kmod-mii
  KCONFIG:=CONFIG_R8168
  FILES:=$(LINUX_DIR)/drivers/net/ethernet/realtek/r8168/r8168.ko
  AUTOLOAD:=$(call AutoProbe,r8168)
endef

$(eval $(call KernelPackage,rtl8168))

define KernelPackage/rtl8169soc/description
  This package contains the Realtek Gigibit Ethernet driver
endef

define KernelPackage/rtd1295hwnat
  SUBMENU:=$(NETWORK_DEVICES_MENU)
  TITLE:=Realtek 1295 HWNAT driver
  KCONFIG:= \
	CONFIG_RTD_1295_HWNAT=y \
	CONFIG_RTD_1295_MAC0_SGMII_LINK_MON=y \
	CONFIG_RTL_HARDWARE_NAT=y \
	CONFIG_RTL_819X=y \
	CONFIG_RTL_HW_NAPT=y \
	CONFIG_RTL_LAYERED_ASIC_DRIVER=y \
	CONFIG_RTL_LAYERED_ASIC_DRIVER_L3=y \
	CONFIG_RTL_LAYERED_ASIC_DRIVER_L4=y \
	CONFIG_RTL_LAYERED_DRIVER_ACL=y \
	CONFIG_RTL_LAYERED_DRIVER_L2=y \
	CONFIG_RTL_LAYERED_DRIVER_L3=y \
	CONFIG_RTL_LAYERED_DRIVER_L4=y \
	CONFIG_RTL_LINKCHG_PROCESS=y \
	CONFIG_RTL_NETIF_MAPPING=y \
	CONFIG_RTL_PROC_DEBUG=y \
	CONFIG_RTL_FASTPATH_HWNAT_SUPPORT_KERNEL_3_X=y \
	CONFIG_RTL_LOG_DEBUG=n \
	CONFIG_RTL865X_ROMEPERF=n \
	CONFIG_RTK_VLAN_SUPPORT=n \
	CONFIG_RTL_EEE_DISABLED=n \
	CONFIG_RTL_SOCK_DEBUG=n \
	CONFIG_RTL_EXCHANGE_PORTMASK=n \
	CONFIG_RTL_INBAND_CTL_ACL=n \
	CONFIG_RTL_ETH_802DOT1X_SUPPORT=n \
	CONFIG_RTL_MULTI_LAN_DEV=y \
	CONFIG_AUTO_DHCP_CHECK=n \
	CONFIG_RTL_HW_MULTICAST_ONLY=n \
	CONFIG_RTL_HW_L2_ONLY=n \
	CONFIG_RTL_MULTIPLE_WAN=n \
	CONFIG_RTL865X_LANPORT_RESTRICTION=n \
	CONFIG_RTL_IVL_SUPPORT=y \
	CONFIG_RTL_LOCAL_PUBLIC=n \
	CONFIG_RTL_HW_DSLITE_SUPPORT=n \
	CONFIG_RTL_HW_6RD_SUPPORT=n \
	CONFIG_RTL_IPTABLES_RULE_2_ACL=n \
	CONFIG_RTL_FAST_FILTER=n \
	CONFIG_RTL_ETH_PRIV_SKB=n \
	CONFIG_RTL_EXT_PORT_SUPPORT=n \
	CONFIG_RTL_HARDWARE_IPV6_SUPPORT=n \
	CONFIG_RTL_ROMEPERF_24K=n \
	CONFIG_RTL_VLAN_PASSTHROUGH_SUPPORT=n \
	CONFIG_RTL_8211F_SUPPORT=n \
	CONFIG_IP_MROUTE_MULTIPLE_TABLES=n \
	CONFIG_IP_MULTIPLE_TABLES=n \
	CONFIG_BRIDGE_IGMP_SNOOPING=n \
	CONFIG_RTL_8367R_SUPPORT=n
  FILES:=
  AUTOLOAD:=
  DEPENDS:=@TARGET_rtd1295 
endef

define KernelPackage/rtd1295hwnat/description
  This package contains the Realtek HW NAT Driver
endef

define KernelPackage/rtd1295hwnat/config
  if PACKAGE_kmod-rtd1295hwnat

	config KERNEL_NF_CONNTRACK
		bool
		default y

	config KERNEL_IP_NF_IPTABLES
		bool
		default n

	config KERNEL_VLAN_8021Q
		bool
		default y

	config KERNEL_RTL_IVL_SUPPORT
		bool
		default n

	config KERNEL_PPP
		bool
		default n

	config KERNEL_RTL_FAST_PPPOE
		bool
		default n

	config KERNEL_RTL_8021Q_VLAN_SUPPORT_SRC_TAG
		bool
		default n

	config KERNEL_RTL_HW_QOS_SUPPORT
		bool "Enable HW QoS support"
		select KERNEL_IP_NF_IPTABLES
		default n
		help
		  Enable HW QoS for HW NAT.

	config KERNEL_RTL_VLAN_8021Q
		bool "Enable HW VLAN support"
		select KERNEL_VLAN_8021Q
		select KERNEL_RTL_IVL_SUPPORT
		default y
		help
		  Enable HW QoS for HW NAT.

	config KERNEL_RTL_TSO
		bool "Enable HW TSO support"
		default y
		depends on !KERNEL_RTL_IPTABLES_FAST_PATH
		help
		  Enable HW TSO for HW NAT.

	config KERNEL_RTL_IPTABLES_FAST_PATH
		bool "Enable fastpath support"
		select KERNEL_NF_CONNTRACK
		select KERNEL_IP_NF_IPTABLES
		select KERNEL_PPP
		select KERNEL_RTL_FAST_PPPOE
		default n
		help
		  Enable fastpath when packets go through CPU.

	config KERNEL_RTL_WAN_MAC5
		bool "Use VLAN 100 of MAC5 as WAN port"
		select KERNEL_VLAN_8021Q
		select KERNEL_RTL_VLAN_8021Q
		default n
		help
		  Disable original WAN (MAC4) port, and use MAC5 as WAN port.
		  WAN (MAC5): eth0.100
		  LAN (MAC5): eth0.200

	config KERNEL_RTL_836X_SUPPORT
		bool "Enable RTL836X series switches support"
		default n
		help
		  Support Realtek RTL8363, RTL8367, RTL8370 series switches.

	config KERNEL_RTL_JUMBO_FRAME
		bool "Enable JUMBO frame support"
		default n
		help
		  Support Realtek RTL8363, RTL8367, RTL8370 series switches.

	config KERNEL_RTL_BR_SHORTCUT
		bool "Enable bridge shortcut"
		depends on RTL8192CD
		default n
		help
		  Enable Bridge Shortcut between WiFi and HW NAT
  endif
endef

$(eval $(call KernelPackage,rtd1295hwnat))

define KernelPackage/rtd1295xen
  SUBMENU:=Virtualization Support
  TITLE:=Realtek 1295 XEN support
  KCONFIG:= \
	CONFIG_HVC_DRIVER=y \
	CONFIG_HVC_IRQ=y \
	CONFIG_HVC_XEN=y \
	CONFIG_HVC_XEN_FRONTEND=y \
	CONFIG_RTK_XEN_SUPPORT=y \
	CONFIG_RTK_DOMU_DMA=y \
	CONFIG_RTK_XEN_HYPERCALL=y \
	CONFIG_RTK_XEN_GPIO=y \
	CONFIG_SWIOTLB_XEN=y \
	CONFIG_SYS_HYPERVISOR=y \
	CONFIG_XEN=y \
	CONFIG_XENFS=y \
	CONFIG_XEN_AUTO_XLATE=y \
	CONFIG_XEN_BACKEND=y \
	CONFIG_XEN_BALLOON=y \
	CONFIG_XEN_BLKDEV_BACKEND=y \
	CONFIG_XEN_BLKDEV_FRONTEND=y \
	CONFIG_XEN_COMPAT_XENFS=y \
	CONFIG_XEN_DEV_EVTCHN=y \
	CONFIG_XEN_DOM0=y \
	CONFIG_XEN_GNTDEV=y \
	CONFIG_XEN_GRANT_DEV_ALLOC=y \
	CONFIG_XEN_NETDEV_BACKEND=y \
	CONFIG_XEN_NETDEV_FRONTEND=y \
	CONFIG_XEN_PRIVCMD=y \
	CONFIG_XEN_SCRUB_PAGES=y \
	CONFIG_XEN_SYS_HYPERVISOR=y \
	CONFIG_XEN_XENBUS_FRONTEND=y \
	CONFIG_XEN_USB_BACKEND=y \
	CONFIG_XEN_USB_FRONTEND=y \
	CONFIG_XEN_USB_SS_PVUSB=y \
	CONFIG_ARM_REALTEK_CPUFREQ_HYSTERESIS=y \
	CONFIG_RTK_ACPU_RELOAD=y \
	CONFIG_RTK_IPCSHM_RESET=y \
	CONFIG_RTK_XEN_DOMU_RSVMEM=n \
	CONFIG_INPUT_EVDEV=y \
	CONFIG_CPUFREQ_OD_HELPER=n \
	CONFIG_CPUFREQ_XEN_DOM0=y \
	CONFIG_CPUFREQ_RTK_XEN_DOM0=y \
	CONFIG_COMMON_CLK_RTK129X=y \
	CONFIG_RTK_SW_LOCK_API=y \
	CONFIG_RTK_XEN_HWLOCK=y \
	CONFIG_XEN_REGDEV_BACKEND=y \
	CONFIG_FB_RTK=y \
	CONFIG_FB_RTK_FPGA=n \
	CONFIG_ANDROID=y \
	CONFIG_ION=y \
	CONFIG_ION_RTK_PHOENIX=y \
	CONFIG_INPUT_MOUSEDEV=y \
	CONFIG_INPUT_MOUSEDEV_PSAUX=y \
	CONFIG_INPUT_MOUSEDEV_SCREEN_X=1024 \
	CONFIG_INPUT_MOUSEDEV_SCREEN_Y=768 \
	CONFIG_THERMAL=y \
	CONFIG_CPU_THERMAL=y \
	CONFIG_RTK_THERMAL=y \
	CONFIG_UIO=y \
	CONFIG_UIO_ASSIGN_MINOR=y \
	CONFIG_UIO_RTK_RBUS=y
  FILES:=
  AUTOLOAD:=
  DEPENDS:=@TARGET_rtd1295 @AUDIO_ADDR_LEGACY +libfdt +yajl +bash +perl
endef

define KernelPackage/rtd1295xen/description
  This package contains the Realtek XEN
endef

$(eval $(call KernelPackage,rtd1295xen))

define KernelPackage/rtd1295cma
  SUBMENU:=$(RTK_MENU)
  TITLE:=Realtek CMA improvement
  KCONFIG:= \
	CONFIG_CMA_IMPROVE=y
  FILES:=
  AUTOLOAD:=
  DEPENDS:=@TARGET_rtd1295
endef

define KernelPackage/rtd1295cma/description
  This package contains the Realtek CMA tweak
endef

$(eval $(call KernelPackage,rtd1295cma))

define KernelPackage/rtd1295-64k
  SUBMENU:=$(RTK_MENU)
  TITLE:=Realtek 64KB page
  KCONFIG:= \
	CONFIG_ARCH_MMAP_RND_BITS_MAX=27 \
	CONFIG_ARCH_MMAP_RND_BITS_MIN=14 \
	CONFIG_ARCH_MMAP_RND_COMPAT_BITS_MIN=7 \
	CONFIG_ARM64_4K_PAGES=n \
	CONFIG_ARM64_64K_PAGES=y \
	CONFIG_ARM64_VA_BITS=42 \
	CONFIG_ARM64_VA_BITS_42=y \
	CONFIG_PGTABLE_LEVELS=2
  FILES:=
  AUTOLOAD:=
  DEPENDS:=@TARGET_rtd1295
endef

define KernelPackage/rtd1295-64k/config
	depends on !PACKAGE_kmod-lib-mali && !PACKAGE_mali-egl
endef

define KernelPackage/rtd1295-64k/description
  This package enables 64KB page size support
endef

$(eval $(call KernelPackage,rtd1295-64k))

define KernelPackage/openmax
  SECTION:=kernel
  CATEGORY:=Kernel modules
  SUBMENU:=$(RTK_MENU)
  TITLE:=OpenMAX kernel options
  KCONFIG:= \
	CONFIG_ION=y \
	CONFIG_ION_TEST=n \
	CONFIG_ION_DUMMY=n \
	CONFIG_ION_RTK_PHOENIX=y \
	CONFIG_FIQ_DEBUGGER=n \
	CONFIG_FSL_MC_BUS=n \
	CONFIG_RTK_CODEC=y \
	CONFIG_RTK_RESERVE_MEMORY=y \
	CONFIG_VE1_CODEC=y \
	CONFIG_VE3_CODEC=y \
	CONFIG_IMAGE_CODEC=y \
	CONFIG_ANDROID=y \
	CONFIG_ASHMEM=y \
	CONFIG_ANDROID_TIMED_OUTPUT=y \
	CONFIG_ANDROID_TIMED_GPIO=n \
	CONFIG_ANDROID_LOW_MEMORY_KILLER=y \
	CONFIG_ANDROID_LOW_MEMORY_KILLER_AUTODETECT_OOM_ADJ_VALUES=y \
	CONFIG_SYNC=y \
	CONFIG_SW_SYNC=y \
	CONFIG_SW_SYNC_USER=y \
	CONFIG_ZSMALLOC=y \
	CONFIG_REGMAP=y \
	CONFIG_REGMAP_I2C=y \
	CONFIG_JUMP_LABEL=y \
	CONFIG_KSM=y \
	CONFIG_UIO=y \
	CONFIG_UIO_ASSIGN_MINOR=y \
	CONFIG_UIO_RTK_RBUS=y \
	CONFIG_UIO_RTK_REFCLK=y \
	CONFIG_UIO_RTK_SE=y \
	CONFIG_UIO_RTK_MD=y \
	CONFIG_STAGING=y \
	CONFIG_FSL_MC_BUS=n \
	CONFIG_CMA=y \
	CONFIG_CMA_DEBUG=n \
	CONFIG_CMA_DEBUGFS=y \
	CONFIG_CMA_AREAS=7 \
	CONFIG_DMA_CMA=y \
	CONFIG_CMA_SIZE_MBYTES=32 \
	CONFIG_CMA_SIZE_SEL_MBYTES=y \
	CONFIG_CMA_SIZE_SEL_PERCENTAGE=n \
	CONFIG_CMA_SIZE_SEL_MIN=n \
	CONFIG_CMA_SIZE_SEL_MAX=n \
	CONFIG_CMA_ALIGNMENT=4 \
	CONFIG_ADF=n \

  DEPENDS:=
  FILES:=
endef

define KernelPackage/openmax/description
  This package enables kernel options for OpenMAX.
endef

$(eval $(call KernelPackage,openmax))

define KernelPackage/rtk-nvr
  SECTION:=kernel
  CATEGORY:=Kernel modules
  SUBMENU:=$(RTK_MENU)
  TITLE:=rtk-nvr kernel options
  KCONFIG:= \
	CONFIG_MEDIA_SUPPORT=y \
	CONFIG_RTK_HDMITX=y \
	CONFIG_RTK_HDCP_1x=y \
	CONFIG_RTK_HDMIRX=n \
	CONFIG_RTK_HDCPRX_2P2=n \
	CONFIG_CEC=n \
	CONFIG_RTD1295_CEC=y \
	CONFIG_RTK_DPTX=y \
	CONFIG_FB=y \
	CONFIG_FB_RTK=y \
	CONFIG_FB_RTK_FPGA=n \
	CONFIG_FB_SIMPLE=y \
	CONFIG_ADF=y \
	CONFIG_ADF_FBDEV=n \
	CONFIG_ADF_MEMBLOCK=n \
	CONFIG_SWITCH_GPIO=n \
	CONFIG_SOUND=y \
	CONFIG_SND=y \
	CONFIG_SND_TIMER=y \
	CONFIG_SND_PCM=y \
	CONFIG_SND_HWDEP=y \
	CONFIG_SND_RAWMIDI=y \
	CONFIG_SND_COMPRESS_OFFLOAD=y \
	CONFIG_SND_JACK=y \
	CONFIG_SND_PCM_TIMER=y \
	CONFIG_SND_HRTIMER=y \
	CONFIG_SND_SUPPORT_OLD_API=y \
	CONFIG_SND_PROC_FS=y \
	CONFIG_SND_VERBOSE_PROCFS=y \
	CONFIG_SND_DRIVERS=y \
	CONFIG_SND_HDA_PREALLOC_SIZE=64 \
	CONFIG_SND_ARM=y \
	CONFIG_SND_ARMAACI=n \
	CONFIG_SND_REALTEK=y \
	CONFIG_SND_USB=y \
	CONFIG_SND_USB_AUDIO=y \
	CONFIG_SND_SOC=y \
	CONFIG_SND_SOC_COMPRESS=y \

  DEPENDS:=@TARGET_rtd1295 \

  FILES:=
endef

define KernelPackage/rtk-nvr/description
  This package enables kernel options for rtk-nvr.
endef

$(eval $(call KernelPackage,rtk-nvr))

define KernelPackage/mali-wayland
  SECTION:=kernel
  CATEGORY:=Kernel modules
  SUBMENU:=$(RTK_MENU)
  TITLE:=mali-wayland kernel options
  KCONFIG:= \
	CONFIG_INPUT_EVDEV=y \
	CONFIG_DMA_SHARED_BUFFER_USES_KDS=y \
  	CONFIG_PM_DEVFREQ=y \
	CONFIG_DEVFREQ_GOV_SIMPLE_ONDEMAND=y \
	CONFIG_ADF=y \
	CONFIG_COMPAT_NETLINK_MESSAGES=y \
	CONFIG_DMA_SHARED_BUFFER=y \
	CONFIG_DRM=y \
	CONFIG_DRM_BRIDGE=y \
	CONFIG_DRM_FBDEV_EMULATION=y \
	CONFIG_DRM_GEM_CMA_HELPER=y \
	CONFIG_DRM_KMS_CMA_HELPER=y \
	CONFIG_DRM_KMS_FB_HELPER=y \
	CONFIG_DRM_KMS_HELPER=y \
	CONFIG_DRM_RTK=y \
	CONFIG_FB=y \
	CONFIG_FB_CFB_COPYAREA=y \
	CONFIG_FB_CFB_FILLRECT=y \
	CONFIG_FB_CFB_IMAGEBLIT=y \
	CONFIG_FB_CMDLINE=y \
	CONFIG_FB_RTK=y \
	CONFIG_FB_SYS_COPYAREA=y \
	CONFIG_FB_SYS_FILLRECT=y \
	CONFIG_FB_SYS_FOPS=y \
	CONFIG_FB_SYS_IMAGEBLIT=y \
	CONFIG_HDMI=y \
	CONFIG_I2C_ALGOBIT=y \
	CONFIG_MEMORY_ISOLATION=y \
	CONFIG_MIGRATION=y \
	CONFIG_PINCTRL_RTK=y \
	CONFIG_PINCTRL_RTD129X=y \
	CONFIG_RTD129X_WATCHDOG=y \
	CONFIG_SW_SYNC=y \
	CONFIG_SW_SYNC_USER=y \
	CONFIG_SYNC=y \

  DEPENDS:=
  FILES:=
endef

define KernelPackage/mali-wayland/description
  This package enables kernel options for mali-wayland.
endef

$(eval $(call KernelPackage,mali-wayland))

define KernelPackage/weston
  SECTION:=kernel
  CATEGORY:=Kernel modules
  SUBMENU:=$(RTK_MENU)
  TITLE:=weston kernel options
  KCONFIG:=CONFIG_CONSOLE_TRANSLATIONS=y \
	CONFIG_DUMMY_CONSOLE=y \
	CONFIG_FONT_8x16=y \
	CONFIG_FONT_8x8=y \
	CONFIG_FONT_SUPPORT=y \
	CONFIG_FRAMEBUFFER_CONSOLE=y \
	CONFIG_FRAMEBUFFER_CONSOLE_DETECT_PRIMARY=y \
	CONFIG_FRAMEBUFFER_CONSOLE_ROTATION=y \
	CONFIG_HW_CONSOLE=y \
	CONFIG_SERIAL_8250_FSL=y \
	CONFIG_SERIAL_8250_PNP=y \
	CONFIG_VT=y \
	CONFIG_VT_CONSOLE=y \
	CONFIG_VT_CONSOLE_SLEEP=y \
	CONFIG_VT_HW_CONSOLE_BINDING=y \
	CONFIG_INPUT_KEYBOARD=y \
	CONFIG_INPUT_MOUSE=y \
	CONFIG_INPUT_MOUSEDEV=y \
	CONFIG_INPUT_MOUSEDEV_PSAUX=y \
	CONFIG_INPUT_MOUSEDEV_SCREEN_X=1024 \
	CONFIG_INPUT_MOUSEDEV_SCREEN_Y=768 \
	CONFIG_KEYBOARD_ATKBD=y \
	CONFIG_MOUSE_PS2=y \
	CONFIG_MOUSE_PS2_ALPS=y \
	CONFIG_MOUSE_PS2_CYPRESS=y \
	CONFIG_MOUSE_PS2_FOCALTECH=y \
	CONFIG_MOUSE_PS2_LOGIPS2PP=y \
	CONFIG_MOUSE_PS2_SYNAPTICS=y \
	CONFIG_MOUSE_PS2_TRACKPOINT=y \
	CONFIG_SERIO=y \
	CONFIG_SERIO_SERPORT=y \
	CONFIG_HID=y \
	CONFIG_HID_GENERIC=y \
	CONFIG_USB_HID=y
  DEPENDS:=
  FILES:=
endef

define KernelPackage/weston/description
  This package enables kernel options for weston.
endef

$(eval $(call KernelPackage,weston))
