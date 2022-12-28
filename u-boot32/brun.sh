#!/bin/bash

### Borads
#rtd1195_qa_nand
#rtd1195_qa_emmc
#rtd1195_qa_spi
#rtd1195_demo_mustang
#rtd1195_demo_horseradish

#TARGET=rtd1195_qa_spi
TARGET=rtd1195_nas_spi
#TARGET=rtd1195_qa_emmc
#TARGET=rtd1195_qa_nand
#TARGET=rtd1195_nas_nand
if [ "$TARGET" = "rtd1195_qa_spi" ] || [ "$TARGET" = "rtd1195_nas_spi" ]; then
OPT='AUTORUN=bcldr'
fi

make clean && \
    make distclean && \
    rm -f include/autoconf.mk && \
    make ${TARGET}_config && \
    make ${OPT}

if [ "$TARGET" = "rtd1195_qa_spi" ] || [ "$TARGET" = "rtd1195_nas_spi" ]; then
    mkdir -p wifihdd
    cp -a u-boot.bin examples/flash_writer_u/bootimage/uboot_textbase_0x00020000.bin
    cp -a bootloader.tar wifihdd/bootloader_nor.tar

#make clean && \
#    make distclean && \
    rm -f include/autoconf.mk && \
    make ${TARGET}_config && \
    make CONFIG_SYS_TEXT_BASE=0x01400000 Config_SPI_BOOTCODE2=TRUE

    cp -a u-boot.bin examples/flash_writer_u/bootimage/uboot_textbase_0x01400000.bin
    cp -a bootloader.tar wifihdd/bootloader2_nor.tar

cp -a examples/flash_writer_u/bootimage/uboot_textbase_0x00020000.bin examples/flash_writer_u/bootimage/uboot_textbase_0x01400000.bin wifihdd/

cp -a ./examples/flash_writer_u/dvrboot.exe.bin wifihdd/
fi

#sudo cp -a ./examples/flash_writer_u/dvrboot.exe.bin /var/lib/tftpboot/dvrboot.${TARGET}.bin
#cp -a ./examples/flash_writer_u/dvrboot.exe.bin /var/lib/tftpboot/dvrboot.${TARGET}.bin

