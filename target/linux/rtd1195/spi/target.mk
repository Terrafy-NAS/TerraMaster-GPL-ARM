BOARDNAME := RTD1195 NAS with SPI
FEATURES += squashfs

KERNEL_PATCHVER:=4.4

define Target/Description
	Build pure NAS firmware image for Realtek RTD1195 SoC devices
	with SPI NOR flash.
endef
