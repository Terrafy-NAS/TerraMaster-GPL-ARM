#include "include/dvrboot_inc/sys_reg.h"
#include "flashdev_s.h"
#include "include/uart.h"

void watchdog_reset(void);

void set_spi_pin_mux(void)
{
#ifndef FPGA	  //wilma+  0802
	//1295
	//set sf_en=1
	REG32(SYS_muxpad5) |= 0x01;
#endif
}

/************************************************************************
 *
 *  dvrmain
 *  Description :
 *  -------------
 *  main function of flash writer
 *  attention:
 *  1. since 0xbfc0_0000 ~ 0xbfc0_1fff occupied by ROM code,
 *     space from 0xbfc0_0000 ~ 0xbfc0_1fff in NOR flash can not be utilized.
 *     In order to write data to the space, we shift writing address space from
 *     0xbed0_0000 ~ 0xbfcf_ffff to 0xbdd0_0000 ~ 0xbecf_ffff. So that we can
 *     access to space 0xbfc0_0000 ~ 0xbfc0_1fff in NOR flash.
 *  2. we left 0xbecf_f000 ~ 0xbecf_ffff for ext_param.
 *  3. ext_param is located from 0xbecf_f800.
 *
 *  Parameters :
 *  Return values :
 *
 ************************************************************************/
extern const unsigned char MP_SRC[];
extern const unsigned int MP_SRC_len;
int dvrmain	( int argc, char * const argv[] )
{
    void *device = NULL;
    // -------------------------------------------------------------------------
    // function declaration
    // -------------------------------------------------------------------------
    int (*do_erase)(void  *, unsigned char * , unsigned int) = NULL;
    int (*do_write)(void *, unsigned char *, unsigned char *, unsigned int, unsigned int, const unsigned int) = NULL;
    int (*do_identify)(void **) = NULL;
    int (*do_init)(void *) = NULL;
    int (*do_read)(void *, unsigned char *, unsigned char *, unsigned int, unsigned int) = NULL;
    void (*do_exit)(void *dev) = NULL;

    init_uart();
    set_focus_uart(0); //default : uart0

    if(1)
    {
        do_identify       = do_identify_s;
        do_init           = do_init_s;
        do_erase          = do_erase_s;
        do_write          = do_write_s;
        do_read           = NULL;
        do_exit           = do_exit_s;

        set_spi_pin_mux();
    }

    prints("starting...\n");
    if (do_identify && ((*do_identify)(&device) < 0))
    {
        prints("\nidentify error!\n");
        return -2;
    }
    if (do_init && ((*do_init)(device)))
    {
        prints("\ninit error!\n");
        return -2;
    }

    prints("\nErasing...\n");
    if (do_erase && ((*do_erase)(device, (unsigned char*)SPI_BASE_ADDR, MP_SRC_len) !=0 ) )
    {
        prints("\nerase error!\n");
        return -3;
    }
    prints("\nWriting...\n");
    if (do_write && ((*do_write)(device, MP_SRC, (unsigned char*)SPI_BASE_ADDR, MP_SRC_len, 0, 0)!= 0 ))
    {
        prints("\nWrite error!\n");
        return -6;
    }
    if(do_exit) (*do_exit)(device);

    prints("Resetting...\n");
    watchdog_reset();

    return 0;
}
