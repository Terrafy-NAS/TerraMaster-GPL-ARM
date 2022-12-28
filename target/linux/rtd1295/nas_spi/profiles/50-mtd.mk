define Profile/giraffe-2GB-mtd
  NAME:=Giraffe 2GB board with SPI NOR
endef

define Profile/giraffe-2GB-mtd/Config
	select RTK_BOARD_CHIP_1295
	select RTK_BOARD_DDR_2GB
	select RTK_BOARD_MTD_LAYOUT
endef

define Profile/giraffe-2GB-mtd/Description
	Giraffe board 2GB with SPI NOR
endef

$(eval $(call Profile,giraffe-2GB-mtd))

define Profile/saola-2GB-mtd
  NAME:=Saola 2GB board with SPI NOR
endef

define Profile/saola-2GB-mtd/Config
	select RTK_BOARD_CHIP_1296
	select RTK_BOARD_DDR_2GB
	select RTK_BOARD_MTD_LAYOUT
endef

define Profile/saola-2GB-mtd/Description
	Saola board 2GB with SPI NOR
endef

$(eval $(call Profile,saola-2GB-mtd))


