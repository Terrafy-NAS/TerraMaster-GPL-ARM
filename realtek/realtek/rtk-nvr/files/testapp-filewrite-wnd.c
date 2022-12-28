/*
 * testapp-filewrite-wnd.c: example for using buffer_write API to write file data to a window
 */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>

#include "rtkcontrol.h"
#include "testapp-utils.h"

// set 1 to enable, default is 0 as disabled
int debuglevel = 1;

#define WAIT_PLAYTIME	180

int main(int argc, char *argv[])
{
    ChannelId ch;
    WindowId wnd;
    ChannelState_e state;
    int i;

    if (argc < 2) {
	printf("Usage: %s <file1> [<file2> ...]\n", argv[0]);
	return 1;
    }

    /* Initialize */
    rtk_serv_initialize();

    /* Set up window and channel */
    wnd = rtk_disp_create(0, 0, 640, 360);
    ch = rtk_dec_add_channel();
    rtk_dec_bind(ch, wnd);
    printf("wnd=%d ch=%d\n", wnd, ch);

    rtk_dec_set_play(CH_STATE_PLAY, ch);

    sleep(1);

    for (i = 1; i < argc; i++) {
	do_filewrite(ch, argv[i]);
    }

    /* Wait for playing */
    printf("sleep %d s\n", WAIT_PLAYTIME);
    sleep(WAIT_PLAYTIME);

    rtk_dec_get_play(ch, &state);
    printf("ch=%d state %d\n", ch, state);


    rtk_disp_set_blank(1, 1, wnd);

    rtk_disp_destroy(wnd);
    sleep(1);


    rtk_dec_set_play(CH_STATE_STOP, ch);

    /* Clean up channel and window */
    rtk_dec_remove_channel(ch);

    /* Terminate */
    rtk_serv_terminate();

    return 0;
}
