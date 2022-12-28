BOARDNAME := RTD1195 Media NAS with eMMC
FEATURES += squashfs
DEFAULT_PACKAGES += kmod-mali

KERNEL_PATCHVER:=3.10

define Target/Description
	Build firmware images for Realtek RTD1195 based boards with
	eMMC.
endef
