/* Copyright (C) 2011
 * Corscience GmbH & Co. KG - Simon Schwarz <schwarz@corscience.de>
 *  - Added prep subcommand support
 *  - Reorganized source - modeled after powerpc version
 *
 * (C) Copyright 2002
 * Sysgo Real-Time Solutions, GmbH <www.elinos.com>
 * Marius Groeger <mgroeger@sysgo.de>
 *
 * Copyright (C) 2001  Erik Mouw (J.A.K.Mouw@its.tudelft.nl)
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.	 See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307	 USA
 *
 */

#include <common.h>
#include <command.h>
#include <image.h>
#include <u-boot/zlib.h>
#include <asm/byteorder.h>
#include <fdt.h>
#include <libfdt.h>
#include <fdt_support.h>
#include <asm/bootm.h>
#include <exports.h>
#include <environment.h>
#include <asm/arch/system.h>
#include <platform_lib/board/pcb_mgr.h>
#include <asm/arch/fw_info.h>
#ifdef CONFIG_APPLY_CUSTOMIZED_FEATURE
#include <customized.h>
#endif


DECLARE_GLOBAL_DATA_PTR;

#if defined(CONFIG_SETUP_MEMORY_TAGS) || \
	defined(CONFIG_CMDLINE_TAG) || \
	defined(CONFIG_INITRD_TAG) || \
	defined(CONFIG_SERIAL_TAG) || \
	defined(CONFIG_REVISION_TAG)
static struct tag *params;
#endif

extern uint *boot_av_info_ptr;

extern BOOT_MODE boot_mode;
/* end */

static ulong get_sp(void)
{
	ulong ret;

	asm("mov %0, sp" : "=r"(ret) : );
	return ret;
}

void arch_lmb_reserve(struct lmb *lmb)
{
	ulong sp;

	/*
	 * Booting a (Linux) kernel image
	 *
	 * Allocate space for command line and board info - the
	 * address should be as high as possible within the reach of
	 * the kernel (see CONFIG_SYS_BOOTMAPSZ settings), but in unused
	 * memory, which means far enough below the current stack
	 * pointer.
	 */
	sp = get_sp();
	debug("## Current stack ends at 0x%08lx ", sp);

	/* adjust sp by 1K to be safe */
	sp -= 1024;
	lmb_reserve(lmb, sp,
		    gd->bd->bi_dram[0].start + gd->bd->bi_dram[0].size - sp);
}

#ifdef CONFIG_OF_LIBFDT
static int fixup_memory_node(void *blob)
{
	bd_t	*bd = gd->bd;
	int bank;
	u64 start[CONFIG_NR_DRAM_BANKS];
	u64 size[CONFIG_NR_DRAM_BANKS];

	for (bank = 0; bank < CONFIG_NR_DRAM_BANKS; bank++) {
		start[bank] = bd->bi_dram[bank].start;
		size[bank] = bd->bi_dram[bank].size;
	}

	return fdt_fixup_memory_banks(blob, start, size, CONFIG_NR_DRAM_BANKS);
}
#endif

static void announce_and_cleanup(void)
{
	printf("Starting kernel ... \n");
	bootstage_mark_name(BOOTSTAGE_ID_BOOTM_HANDOFF, "start_kernel");
#ifdef CONFIG_BOOTSTAGE_REPORT
	bootstage_report();
#endif

#ifdef CONFIG_USB_DEVICE
	udc_disconnect();
#endif
	cleanup_before_linux();
}

#if defined(CONFIG_SETUP_MEMORY_TAGS) || \
	defined(CONFIG_CMDLINE_TAG) || \
	defined(CONFIG_INITRD_TAG) || \
	defined(CONFIG_SERIAL_TAG) || \
	defined(CONFIG_REVISION_TAG)
static void setup_start_tag (bd_t *bd)
{
	params = (struct tag *)bd->bi_boot_params;

	params->hdr.tag = ATAG_CORE;
	params->hdr.size = tag_size (tag_core);

	params->u.core.flags = 0;
	params->u.core.pagesize = 0;
	params->u.core.rootdev = 0;

	params = tag_next (params);
}
#endif

#ifdef CONFIG_SETUP_MEMORY_TAGS
static void setup_memory_tags(bd_t *bd)
{
	int i;

	for (i = 0; i < CONFIG_NR_DRAM_BANKS; i++) {
		params->hdr.tag = ATAG_MEM;
		params->hdr.size = tag_size (tag_mem32);

		params->u.mem.start = bd->bi_dram[i].start;
		params->u.mem.size = bd->bi_dram[i].size;

		params = tag_next (params);
	}
}
#endif

#ifdef CONFIG_CMDLINE_TAG
static void setup_commandline_tag(bd_t *bd, char *commandline)
{
	char *p;

	if (!commandline)
		return;

	/* eat leading white space */
	for (p = commandline; *p == ' '; p++);

	/* skip non-existent command lines so the kernel will still
	 * use its default command line.
	 */
	if (*p == '\0')
		return;

	params->hdr.tag = ATAG_CMDLINE;
	params->hdr.size =
		(sizeof (struct tag_header) + strlen (p) + 1 + 4) >> 2;

	strcpy (params->u.cmdline.cmdline, p);

	params = tag_next (params);
}
#endif

#ifdef CONFIG_INITRD_TAG
static void setup_initrd_tag(bd_t *bd, ulong initrd_start, ulong initrd_end)
{
	/* an ATAG_INITRD node tells the kernel where the compressed
	 * ramdisk can be found. ATAG_RDIMG is a better name, actually.
	 */
	params->hdr.tag = ATAG_INITRD2;
	params->hdr.size = tag_size (tag_initrd);

	params->u.initrd.start = initrd_start;
	params->u.initrd.size = initrd_end - initrd_start;

	params = tag_next (params);
}
#endif

#ifdef CONFIG_SERIAL_TAG
void setup_serial_tag(struct tag **tmp)
{
	struct tag *params = *tmp;
	struct tag_serialnr serialnr;
	void get_board_serial(struct tag_serialnr *serialnr);

	get_board_serial(&serialnr);
	params->hdr.tag = ATAG_SERIAL;
	params->hdr.size = tag_size (tag_serialnr);
	params->u.serialnr.low = serialnr.low;
	params->u.serialnr.high= serialnr.high;
	params = tag_next (params);
	*tmp = params;
}
#endif

#ifdef CONFIG_REVISION_TAG
void setup_revision_tag(struct tag **in_params)
{
	u32 rev = 0;
	u32 get_board_rev(void);

	rev = get_board_rev();
	params->hdr.tag = ATAG_REVISION;
	params->hdr.size = tag_size (tag_revision);
	params->u.revision.rev = rev;
	params = tag_next (params);
}
#endif

#if defined(CONFIG_SETUP_MEMORY_TAGS) || \
	defined(CONFIG_CMDLINE_TAG) || \
	defined(CONFIG_INITRD_TAG) || \
	defined(CONFIG_SERIAL_TAG) || \
	defined(CONFIG_REVISION_TAG)
static void setup_end_tag(bd_t *bd)
{
	params->hdr.tag = ATAG_NONE;
	params->hdr.size = 0;
}
#endif

#ifdef CONFIG_OF_LIBFDT
static int create_fdt(bootm_headers_t *images)
{
	ulong of_size = images->ft_len;
	char **of_flat_tree = &images->ft_addr;
	ulong *initrd_start = &images->initrd_start;
	ulong *initrd_end = &images->initrd_end;
	struct lmb *lmb = &images->lmb;
	ulong rd_len;
	int ret;

	debug("using: FDT\n");
#ifndef CONFIG_RTD1195
	boot_fdt_add_mem_rsv_regions(lmb, *of_flat_tree);

	rd_len = images->rd_end - images->rd_start;
	ret = boot_ramdisk_high(lmb, images->rd_start, rd_len,
			initrd_start, initrd_end);
	if (ret)
		return ret;

	ret = boot_relocate_fdt(lmb, of_flat_tree, &of_size);
	if (ret)
		return ret;
#endif
	fdt_chosen(*of_flat_tree, 1);
#ifndef CONFIG_RTD1195
	fixup_memory_node(*of_flat_tree);
	fdt_fixup_ethernet(*of_flat_tree);
	fdt_initrd(*of_flat_tree, *initrd_start, *initrd_end, 1);
#endif
	return 0;
}
#endif

/**********************************************************
 * Append the pointer information of env_vars to bootargs.
 **********************************************************/
static int rtk_plat_boot_prep_envp(void)
{
#if defined(CONFIG_RTD299X) || defined(CONFIG_RTD1195)
	char *commandline = getenv("bootargs");
	char *tmp_cmdline = NULL;
	int len = 0;

	if (env_export() < 0) {
		printf("[ERR] %s: Cannot export environment\n", __func__);
	}
	else {
		len = strlen(commandline) + 16;

		tmp_cmdline = (char *)malloc(len);
		if (!tmp_cmdline) {
			printf("[ERR] %s: Malloc failed\n", __func__);
		}
		else {
			memset(tmp_cmdline, 0, len);

			sprintf(tmp_cmdline, "%s envp=%lx", commandline, (ulong)env_get_export_all());

			setenv("bootargs", tmp_cmdline);

			free(tmp_cmdline);
		}
	}
#endif

	return 0;
}

/**********************************************************
 * Append the flash type information to bootargs.
 **********************************************************/
static int rtk_plat_boot_prep_flashtype(void)
{
#if defined(CONFIG_RTD299X) || defined(CONFIG_RTD1195)
	char *commandline = getenv("bootargs");
	char *tmp_cmdline = NULL;
	int len = 0;

	len = strlen(commandline) + 16;

	tmp_cmdline = (char *)malloc(len);
	if (!tmp_cmdline) {
		printf("[ERR] %s: Malloc failed\n", __func__);
	}
	else {
		memset(tmp_cmdline, 0, len);

		sprintf(tmp_cmdline, "%s flashtype=%s", commandline, pcb_get_boot_flash_type_string());

		setenv("bootargs", tmp_cmdline);

		free(tmp_cmdline);
	}
#endif

	return 0;
}

/**********************************************************
 * Append the reclaim memory information to bootargs.
 **********************************************************/
static int rtk_plat_boot_prep_reclaim(void)
{
#if 0
	char *commandline = getenv("bootargs");
	char *tmp_cmdline = NULL;
	int len = 0;

	len = strlen(commandline) + 24;

	tmp_cmdline = (char *)malloc(len);
	if (!tmp_cmdline) {
		printf("[ERR] %s: Malloc failed\n", __func__);
	}
	else {
		memset(tmp_cmdline, 0, len);

		sprintf(tmp_cmdline, "%s reclaim=%dM@%dM", commandline,
			KERNEL_RESERVE_FOR_POM_POV_SIZE >> 20,
			KERNEL_RESERVE_FOR_POM_POV_ADDR >> 20);

		setenv("bootargs", tmp_cmdline);

		free(tmp_cmdline);
	}
#endif

	return 0;
}

/**********************************************************
 * Append standby information to bootargs.
 **********************************************************/
static int rtk_plat_boot_prep_for_standby(void)
{
#if defined(CONFIG_RTD299X) || defined(CONFIG_RTD1195)
	char *commandline = getenv("bootargs");
	char *tmp_cmdline = NULL;
	char *tmp_cmdline_emcu = NULL;
	int len = 0;
	extern uchar boot_ac_on;
printf("[DEBUG]%s:%d\n",__FUNCTION__,__LINE__);
	len = strlen(commandline) + 24;

	tmp_cmdline = (char *)malloc(len);
	tmp_cmdline_emcu = (char *)malloc(24);

	if ((!tmp_cmdline) || (!tmp_cmdline_emcu)) {
		printf("[ERR] %s: Malloc failed\n", __func__);
	}
	else {
		memset(tmp_cmdline, 0, len);
		memset(tmp_cmdline_emcu, 0, 24);

		strcpy(tmp_cmdline_emcu, "POWERDOWN");

		if (boot_ac_on) {
			strcat(tmp_cmdline_emcu, " ac_on");
		}

		sprintf(tmp_cmdline, "%s %s", commandline, tmp_cmdline_emcu);

		setenv("bootargs", tmp_cmdline);

		free(tmp_cmdline);
		free(tmp_cmdline_emcu);
	}
	printf("[DEBUG]%s:%d\n",__FUNCTION__,__LINE__);
#endif

	return 0;
}

#if 0 // mark this API that prevent kernel spend more booting time
/**********************************************************
 * Append the network information to bootargs.
 **********************************************************/
static int rtk_plat_boot_prep_network(void)
{
#if defined(CONFIG_RTD299X) || defined(CONFIG_RTD1195)
	char *commandline = getenv("bootargs");
	char *tmp_cmdline = NULL;
	int len = 0;

	len = strlen(commandline) + 64;

	tmp_cmdline = (char *)malloc(len);
	if (!tmp_cmdline) {
		printf("[ERR] %s: Malloc failed\n", __func__);
	}
	else {
		memset(tmp_cmdline, 0, len);

		sprintf(tmp_cmdline, "%s ip=%s::%s:%s", commandline, getenv("ipaddr"), getenv("gatewayip"), getenv("netmask"));

		setenv("bootargs", tmp_cmdline);

		free(tmp_cmdline);
	}
#endif

	return 0;
}
#endif

#if 0 // mark this API to use CONFIG_SETUP_MEMORY_TAGS
/**********************************************************
 * Append the information of memory to bootargs.
 **********************************************************/
static int rtk_plat_boot_prep_mem(void)
{
#if defined(CONFIG_RTD299X) || defined(CONFIG_RTD1195)
	char *commandline = getenv("bootargs");
	char *tmp_cmdline = NULL;

	tmp_cmdline = (char *)malloc(strlen(commandline) + 20);
	if (!tmp_cmdline) {
		printf("%s: Malloc failed\n", __func__);
	}
	else {
		sprintf(tmp_cmdline, "%s mem=%s", commandline, getenv("memsize"));

		setenv("bootargs", tmp_cmdline);

		free(tmp_cmdline);
	}

#endif

	return 0;
}
#endif

/**********************************************************
 * Append the information of partition to bootargs.
 **********************************************************/
static int rtk_plat_boot_prep_partition(void)
{
#ifndef NAS_ENABLE
	if(boot_mode == BOOT_RESCUE_MODE)
		return 0;
#endif
		
#if defined(CONFIG_RTD1195)
	char *commandline = getenv("bootargs");
	char *tmp_cmdline = NULL;

	tmp_cmdline = (char *)malloc(strlen(commandline) + strlen(getenv("mtd_part"))+2);
	if (!tmp_cmdline) {
		printf("%s: Malloc failed\n", __func__);
	}
	else {
		sprintf(tmp_cmdline, "%s %s", commandline, getenv("mtd_part"));
		setenv("bootargs", tmp_cmdline);		
		free(tmp_cmdline);
	}
	debug("%s\n",getenv("bootargs"));
#endif

	return 0;
}

#if defined(CONFIG_RTD1195) && defined(NAS_ENABLE)
extern uint initrd_size;
/**********************************************************
 * Append NAS partitions to bootargs.
 **********************************************************/
static int rtk_plat_boot_prep_nas_partition(void)
{
	char *commandline = getenv("bootargs");
	char *nas_part = getenv("nas_part");
	char *tmp_cmdline = NULL;
	char initrd[32] = {0};

	if(boot_mode == BOOT_RESCUE_MODE && initrd_size != 0)
	{
		sprintf(initrd, "initrd=%s,0x%08x", getenv("rootfs_loadaddr"), initrd_size);
	}

	if (!nas_part && !initrd[0])
	    return 0;

	// Need 3 extra bytes for space and null charactors.
	tmp_cmdline = (char *)malloc(strlen(commandline) + strlen(nas_part) + strlen(initrd) + 3);
	if (!tmp_cmdline) {
		printf("%s: Malloc failed\n", __func__);
	}
	else {
		if (nas_part)
			sprintf(tmp_cmdline, "%s %s %s", commandline, nas_part, initrd);
		else
			sprintf(tmp_cmdline, "%s %s", commandline, initrd);
		setenv("bootargs", tmp_cmdline);
		free(tmp_cmdline);
	}
	debug("%s\n",getenv("bootargs"));

	return 0;
}
#endif

/* Subcommand: PREP */
static void boot_prep_linux(bootm_headers_t *images)
{
#ifdef CONFIG_CMDLINE_TAG
	char *commandline = NULL;

//#if defined(CONFIG_RTD299X) || defined(CONFIG_RTD1195)
//	rtk_plat_boot_prep_mem(); // mark this to use CONFIG_SETUP_MEMORY_TAGS
//	rtk_plat_boot_prep_envp();
//	rtk_plat_boot_prep_network(); // mark this API that prevent kernel spend more booting time
//	rtk_plat_boot_prep_flashtype();

//	if (*boot_av_info_ptr != 0)
//	{
//		printf("boot animation ...\n");
//		rtk_plat_boot_prep_reclaim();
//	}
//#endif

#ifdef CONFIG_SYS_RTK_NAND_FLASH	
	rtk_plat_boot_prep_partition();	
#endif	
#if defined(CONFIG_RTD1195) && defined(NAS_ENABLE)
	rtk_plat_boot_prep_nas_partition();
#endif
#ifdef CONFIG_APPLY_CUSTOMIZED_FEATURE
	EXECUTE_CUSTOMIZED_FUNCTION_2	
#endif
	commandline = getenv("bootargs");
#endif

#ifdef CONFIG_OF_LIBFDT
	if (images->ft_len) {
		debug("using: FDT\n");		
		if (create_fdt(images)) {
			printf("FDT creation failed! hanging...");
			hang();
		}		
	} else
#endif
	{
#if defined(CONFIG_SETUP_MEMORY_TAGS) || \
	defined(CONFIG_CMDLINE_TAG) || \
	defined(CONFIG_INITRD_TAG) || \
	defined(CONFIG_SERIAL_TAG) || \
	defined(CONFIG_REVISION_TAG)
		debug("using: ATAGS\n");
		setup_start_tag(gd->bd);
#ifdef CONFIG_SERIAL_TAG
		setup_serial_tag(&params);
#endif
#ifdef CONFIG_CMDLINE_TAG
		setup_commandline_tag(gd->bd, commandline);
#endif
#ifdef CONFIG_REVISION_TAG
		setup_revision_tag(&params);
#endif
#ifdef CONFIG_SETUP_MEMORY_TAGS
		setup_memory_tags(gd->bd);
#endif
#ifdef CONFIG_INITRD_TAG
		if (images->rd_start && images->rd_end)
			setup_initrd_tag(gd->bd, images->rd_start,
			images->rd_end);
#endif
		setup_end_tag(gd->bd);
#else /* all tags */
		printf("FDT and ATAGS support not compiled in - hanging\n");
		hang();
#endif /* all tags */
	}
}

//#define DEBUG_DUMP_ENV_RESULT
#ifdef DEBUG_DUMP_ENV_RESULT
int *_prom_envp;
#define GET_ENV(index) ((char *)(int)_prom_envp[(index)])
#endif

/* Subcommand: GO */
static void boot_jump_linux(bootm_headers_t *images)
{
	unsigned long machid = gd->bd->bi_arch_number;
	char *s;
#ifdef CONFIG_TEE	
	extern uint tee_enable;
	void (*tee_kernel_entry)(int zero, int arch, uint params, ulong ep);
#endif
	void (*kernel_entry)(int zero, int arch, uint params);
	
	unsigned long r2;
#ifdef CONFIG_TEE
	tee_kernel_entry = (void (*)(int, int, uint, ulong))(CONFIG_TEE_ADDRESS);
#endif	
	kernel_entry = (void (*)(int, int, uint))images->ep;

	s = getenv("machid");
	if (s) {
		strict_strtoul(s, 16, &machid);
		printf("Using machid 0x%lx from environment\n", machid);
	}

	debug("## Transferring control to Linux (at address %08lx)" \
		"...\n", (ulong) kernel_entry);
	bootstage_mark(BOOTSTAGE_ID_RUN_OS);
	announce_and_cleanup();
#ifdef CONFIG_OF_LIBFDT
	if (images->ft_len)
		r2 = (unsigned long)images->ft_addr;
	else
#endif
		r2 = gd->bd->bi_boot_params;

#if defined(CONFIG_RTD299X) || defined(CONFIG_RTD1195)
	debug("bootargs=%s\n", getenv("bootargs"));
	debug("%s 0x%08x(0x%x,0x%lx,0x%lx)\n", __func__, (unsigned int)kernel_entry, 0, machid, r2);
#endif
#ifdef CONFIG_TEE	
	if ((tee_enable==1)&&(boot_mode==BOOT_NORMAL_MODE))
		tee_kernel_entry(0, machid, r2, images->ep);
#endif
	kernel_entry(0, machid, r2);
}

/* Main Entry point for arm bootm implementation
 *
 * Modeled after the powerpc implementation
 * DIFFERENCE: Instead of calling prep and go at the end
 * they are called if subcommand is equal 0.
 */
int do_bootm_linux(int flag, int argc, char *argv[], bootm_headers_t *images)
{
	/* No need for those on ARM */
	if (flag & BOOTM_STATE_OS_BD_T || flag & BOOTM_STATE_OS_CMDLINE)
		return -1;

	if (flag & BOOTM_STATE_OS_PREP) {
		boot_prep_linux(images);
		return 0;
	}

	if (flag & BOOTM_STATE_OS_GO) {
		boot_jump_linux(images);
		return 0;
	}
	
	boot_prep_linux(images);
	boot_jump_linux(images);
	return 0;
}

#ifdef CONFIG_CMD_BOOTZ

struct zimage_header {
	uint32_t	code[9];
	uint32_t	zi_magic;
	uint32_t	zi_start;
	uint32_t	zi_end;
};

#define	LINUX_ARM_ZIMAGE_MAGIC	0x016f2818

int bootz_setup(void *image, void **start, void **end)
{
	struct zimage_header *zi = (struct zimage_header *)image;

	if (zi->zi_magic != LINUX_ARM_ZIMAGE_MAGIC) {
		puts("Bad Linux ARM zImage magic!\n");
		return 1;
	}

	*start = (void *)zi->zi_start;
	*end = (void *)zi->zi_end;

	debug("Kernel image @ 0x%08x [ 0x%08x - 0x%08x ]\n",
		(uint32_t)image, (uint32_t)*start, (uint32_t)*end);

	return 0;
}
#endif	/* CONFIG_CMD_BOOTZ */
