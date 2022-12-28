define Package/base-files/install-target

 ifeq ($(CONFIG_RTD_1295_HWNAT),y)
	sed -i 's|192.168.0.9|192.168.1.9|g' $(1)/etc/config/network
	cat $(PLATFORM_DIR)/conf/network.nat >> $(1)/etc/config/network
 else
	sed -i 's|wan|lan|g' $(1)/etc/config/network
 endif

	cat $(PLATFORM_DIR)/conf/network.guest >> $(1)/etc/config/network

 ifeq ($(CONFIG_TARGET_rtd1295_nas_spi),y)
	rm -rf  $(1)/usr/local/bin/chariot
 endif
 ifeq ($(CONFIG_RTK_BOARD_MTD_LAYOUT),y)
	rm -f  $(1)/lib/preinit/45_mount_overlayfs
	cp $(PLATFORM_DIR)/$(SUBTARGET)/upgrade/platform.sh $(1)/lib/upgrade/
	sed -i 's|\(ROOTFS_SIZE=\).*|\1$(CONFIG_RTK_MTD_ROOTFS_SIZE)|g' $(1)/lib/upgrade/platform.sh
	sed -i 's|\(UBOOT_SIZE=\).*|\1$(CONFIG_RTK_MTD_UBOOT_SIZE)|g' $(1)/lib/upgrade/platform.sh
	sed -i 's|\(KERNEL_SIZE=\).*|\1$(CONFIG_RTK_MTD_KERNEL_SIZE)|g' $(1)/lib/upgrade/platform.sh
	sed -i 's|\(DTB_SIZE=\).*|\1$(CONFIG_RTK_MTD_DTB_SIZE)|g' $(1)/lib/upgrade/platform.sh
	sed -i 's|\(AFW_SIZE=\).*|\1$(CONFIG_RTK_MTD_AFW_SIZE)|g' $(1)/lib/upgrade/platform.sh
	sed -i 's|\(LOGO_SIZE=\).*|\1$(CONFIG_RTK_MTD_LOGO_SIZE)|g' $(1)/lib/upgrade/platform.sh
 endif
endef
