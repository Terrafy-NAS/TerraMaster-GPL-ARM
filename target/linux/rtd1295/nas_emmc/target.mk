BOARDNAME := RTD1295 NAS with eMMC
FEATURES += squashfs

KERNEL_PATCHVER:=4.4

define Target/Description
	Build pure NAS firmware image for Realtek RTD1295 SoC devices.
	Currently produces eMMC image for Giraffe board.
endef
