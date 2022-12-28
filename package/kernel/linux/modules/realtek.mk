RTK_MENU:=Realtek kernel options

define KernelPackage/ipt-android
  SUBMENU:=$(RTK_MENU)
  TITLE:=Extra Netfilter options for Android
  KCONFIG:= \
	CONFIG_NFT_COMPAT=n \
	CONFIG_NF_CT_NETLINK_HELPER=n \
	CONFIG_NF_TABLES_ARP=n \
	CONFIG_NF_TABLES_BRIDGE=n \
	$(addsuffix =y,$(KCONFIG_IPT_ANDROID))
  FILES:=
  AUTOLOAD:=
  DEPENDS:=@TARGET_rtd1295
endef

define KernelPackage/ipt-android/description
 Other Netfilter kernel builtin options for Android
endef

$(eval $(call KernelPackage,ipt-android))

define KernelPackage/rtk_uio
  SUBMENU:=$(RTK_MENU)
  TITLE:=UIO
  KCONFIG:= \
	CONFIG_UIO=y \
	CONFIG_UIO_ASSIGN_MINOR=y \
	CONFIG_UIO_RTK_RBUS=y \
  FILES:=
  AUTOLOAD:=
  DEPENDS:=@TARGET_rtd1295
endef

define KernelPackage/rtk_uio/description
 Realtek UIO kernel options for reg
endef

$(eval $(call KernelPackage,rtk_uio))
