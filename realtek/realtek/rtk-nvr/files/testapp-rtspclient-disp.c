/*
 * testapp-rtspclient-disp.c: example for using rtksink (buffer_write API) to write liveview data to display
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

int main(int argc, const char **argv)
{
    ChannelId channelID[9];
    WindowId wndlID[9];
    char *uri = NULL;
    char *filepath = NULL;
    pid_t pid;
    int i;

    if (argc < 3) {
	printf("Usage: %s <rtsp://IPaddress:port/stream> </path/to>\n", argv[0]);
	printf("Example: %s rtsp://192.168.0.188:43794/profile1 /mnt/sda1\n", argv[0]);
	return 1;
    }

    uri = strdup(argv[1]);
    printf("Play %s\n", uri);

    filepath = strdup (argv[2]);
    printf ("files path : %s\n", filepath);

    struct stat st = {0};
    if (stat(filepath, &st) == -1)
    {
      printf ("%s does not exit!\n", filepath);
      return 1;
    }
    else if ((st.st_mode & S_IFMT) != S_IFDIR)
    {
      printf ("%s is not a directory!\n", filepath);
      return 1;
    }

    /* Initialize */
    rtk_serv_initialize();

    channelID[0] = rtk_dec_add_channel();
    channelID[1] = rtk_dec_add_channel();
    channelID[2] = rtk_dec_add_channel();
    channelID[3] = rtk_dec_add_channel();
    channelID[4] = rtk_dec_add_channel();
    channelID[5] = rtk_dec_add_channel();
    channelID[6] = rtk_dec_add_channel();
    channelID[7] = rtk_dec_add_channel();
    channelID[8] = rtk_dec_add_channel();

    wndlID[0] = rtk_disp_create(0, 0, 640, 360);
    wndlID[1] = rtk_disp_create(0, 360, 640, 360);
    wndlID[2] = rtk_disp_create(0, 720, 640, 360);
    wndlID[3] = rtk_disp_create(640, 0, 640, 360);
    wndlID[4] = rtk_disp_create(640, 360, 640, 360);
    wndlID[5] = rtk_disp_create(640, 720, 640, 360);
    wndlID[6] = rtk_disp_create(1280, 0, 640, 360);
    wndlID[7] = rtk_disp_create(1280, 360, 640, 360);
    wndlID[8] = rtk_disp_create(1280, 720, 640, 360);

    rtk_dec_bind(channelID[0], wndlID[0]);
    rtk_dec_bind(channelID[1], wndlID[1]);
    rtk_dec_bind(channelID[2], wndlID[2]);
    rtk_dec_bind(channelID[3], wndlID[3]);
    rtk_dec_bind(channelID[4], wndlID[4]);
    rtk_dec_bind(channelID[5], wndlID[5]);
    rtk_dec_bind(channelID[6], wndlID[6]);
    rtk_dec_bind(channelID[7], wndlID[7]);
    rtk_dec_bind(channelID[8], wndlID[8]);

    for (i = 0; i < 9; i++) {
        rtk_dec_set_play(CH_STATE_PLAY, channelID[i]);
        sleep(1);
    }

    sleep(3);
    for (i = 0; i < 9; i++) {
	pid = fork();
	if (pid == 0) {		// child
        char channel_id_num[10];
        char filename[128];
        sprintf(channel_id_num,"%d", channelID[i]);
        sprintf(filename, "%s/ipcamera_for_test%d.ts", filepath, i);
		execl("./test-rtspclient", "./test-rtspclient", uri, channel_id_num, filename, NULL);
        sleep(1);
		return 0;
	}
	// parent
    }

	sleep(3);
    //get snapshot
    //printf("snapshot test...\n");
    //rtk_snapshot_display("./snapshot0.jpg");

    sleep(10);

    while(1){

    //blank test
    printf("blank test...\n");
    rtk_disp_set_blank(1, 5, wndlID[0], wndlID[2], wndlID[4],
		       wndlID[6], wndlID[8]);
    sleep(5);
    rtk_disp_set_blank(0, 5, wndlID[0], wndlID[2], wndlID[4],
		       wndlID[6], wndlID[8]);
    rtk_disp_set_blank(1, 4, wndlID[1], wndlID[3], wndlID[5],
		       wndlID[7]);
    sleep(5);
    rtk_disp_set_blank(0, 4, wndlID[1], wndlID[3], wndlID[5],
		       wndlID[7]);
    sleep(5);


    //resize test: channel 0 full screen
    printf("full screen test...\n");
    rtk_disp_resize(channelID[1], 0, 0, 0, 0);
    rtk_disp_resize(channelID[2], 0, 0, 0, 0);
    rtk_disp_resize(channelID[3], 0, 0, 0, 0);
    rtk_disp_resize(channelID[4], 0, 0, 0, 0);
    rtk_disp_resize(channelID[5], 0, 0, 0, 0);
    rtk_disp_resize(channelID[6], 0, 0, 0, 0);
    rtk_disp_resize(channelID[7], 0, 0, 0, 0);
    rtk_disp_resize(channelID[8], 0, 0, 0, 0);
    rtk_disp_resize(channelID[0], 0, 0, 1920, 1080);

    sleep(15);

    //resize test: modify the display layout and only show channel 1, 2
    printf("resize test...\n");
    rtk_disp_resize(channelID[0], 0, 0, 1536, 810);
    rtk_disp_resize(channelID[1], 0, 810, 384, 270);
    rtk_disp_resize(channelID[2], 384, 810, 384, 270);
    rtk_disp_resize(channelID[3], 768, 810, 384, 270);
    rtk_disp_resize(channelID[4], 1152, 810, 384, 270);
    rtk_disp_resize(channelID[5], 1536, 810, 384, 270);
    rtk_disp_resize(channelID[6], 1536, 0, 384, 270);
    rtk_disp_resize(channelID[7], 1536, 270, 384, 270);
    rtk_disp_resize(channelID[8], 1536, 540, 384, 270);

    sleep(15);

    rtk_disp_set_blank(1, 7, wndlID[1], wndlID[2], wndlID[3],
		       wndlID[4], wndlID[6], wndlID[7],
		       wndlID[8]);

    //zoom in test: zoom in channel 1
    printf("zoom in test...\n");
    rtk_disp_crop(channelID[0], 120, 60, 360, 240);
    sleep(15);
    rtk_disp_crop(channelID[0], 0, 0, 1280, 720);
    sleep(10);
    rtk_disp_set_blank(0, 7, wndlID[1], wndlID[2], wndlID[3],
		       wndlID[4], wndlID[6], wndlID[7],
		       wndlID[8]);

    sleep(10);

	rtk_disp_resize(channelID[0], 0, 0, 640, 360);
	rtk_disp_resize(channelID[1], 0, 360, 640, 360);
	rtk_disp_resize(channelID[2], 0, 720, 640, 360);
	rtk_disp_resize(channelID[3], 640, 0, 640, 360);
	rtk_disp_resize(channelID[4], 640, 360, 640, 360);
	rtk_disp_resize(channelID[5], 640, 720, 640, 360);
	rtk_disp_resize(channelID[6], 1280, 0, 640, 360);
	rtk_disp_resize(channelID[7], 1280, 360, 640, 360);
	rtk_disp_resize(channelID[8], 1280, 720, 640, 360);   
	}


	rtk_disp_destroy(wndlID[0]);
    rtk_disp_destroy(wndlID[1]);
    rtk_disp_destroy(wndlID[2]);
    rtk_disp_destroy(wndlID[3]);
    rtk_disp_destroy(wndlID[4]);
    rtk_disp_destroy(wndlID[5]);
    rtk_disp_destroy(wndlID[6]);
    rtk_disp_destroy(wndlID[7]);
    rtk_disp_destroy(wndlID[8]);

    rtk_dec_set_play(CH_STATE_STOP, channelID[0]);
    rtk_dec_set_play(CH_STATE_STOP, channelID[1]);
    rtk_dec_set_play(CH_STATE_STOP, channelID[2]);
    rtk_dec_set_play(CH_STATE_STOP, channelID[3]);
    rtk_dec_set_play(CH_STATE_STOP, channelID[4]);
    rtk_dec_set_play(CH_STATE_STOP, channelID[5]);
    rtk_dec_set_play(CH_STATE_STOP, channelID[6]);
    rtk_dec_set_play(CH_STATE_STOP, channelID[7]);
    rtk_dec_set_play(CH_STATE_STOP, channelID[8]);

    rtk_dec_remove_channel(channelID[0]);
    rtk_dec_remove_channel(channelID[1]);
    rtk_dec_remove_channel(channelID[2]);
    rtk_dec_remove_channel(channelID[3]);
    rtk_dec_remove_channel(channelID[4]);
    rtk_dec_remove_channel(channelID[5]);
    rtk_dec_remove_channel(channelID[6]);
    rtk_dec_remove_channel(channelID[7]);
    rtk_dec_remove_channel(channelID[8]);

	free(uri);
	free(filepath);
    /* Terminate */
    rtk_serv_terminate();

    return 0;
}
