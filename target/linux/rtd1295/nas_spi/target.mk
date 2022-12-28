BOARDNAME := RTD1296 NAS with SPI
FEATURES += squashfs

KERNEL_PATCHVER:=4.4

define Target/Description
	Build pure NAS firmware image for Realtek RTD1296 SoC devices.
	Currently produces SPI image for Saola board.
endef
