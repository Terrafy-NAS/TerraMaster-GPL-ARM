BOARDNAME := RTD1295 NAS with NAND flash
FEATURES += squashfs ubifs

KERNEL_PATCHVER:=4.4

define Target/Description
	Build pure NAS firmware image for Realtek RTD129X SoC devices.
	Currently produces NAND image for Giraffe board.
endef
