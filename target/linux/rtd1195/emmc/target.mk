BOARDNAME := Generic devices with eMMC
FEATURES += squashfs

KERNEL_PATCHVER:=3.10

define Target/Description
	Build firmware images for Realtek RTD1195 based boards with
	eMMC.
endef
