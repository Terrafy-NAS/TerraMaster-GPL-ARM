BOARDNAME := RTD1195 NAS with NAND flash
FEATURES += squashfs ubifs

KERNEL_PATCHVER:=4.4

define Target/Description
	Build firmware images for Realtek RTD1195 based boards with
	NAND flash.
endef
