#include <stdio.h>
#include <string.h>
#include <unistd.h>
#include <stdlib.h>
#include "rtkcontrol.h"

void printUsage(void)
{
	printf("\n\n");
	printf("Usage:\n");
	printf("\t./testapp-playback [OPTION] [FILEPATH]\n");
	printf("[OPTION]\n");
	printf("\t-a: audio test. Mute, Volume......(Default: disable)\n");
	printf("\t-v: video test. Blank, Resize, Crop...... (Default: disable)\n");
	printf("\t-d: DP output. (Default: disable)\n");
	printf("\t-h: HDMI output. (Default: enable)\n");
	printf("\t-s: single channel output. (Default: disable)\n");
	printf("\n[FILEPATH]\n");
    printf("\tEX: /root/nfs/Testfiles/mp4/720p.mp4\n\n");
}

int main(int argc, char* argv[])
{
    ChannelId channelID[9];
    WindowId wndlID[9];
    double volume;
    char *filename = NULL;
    int ch;
    unsigned int audioTest = 0;
    unsigned int videoTest = 0;
    unsigned int hdmiOutput = 0;
    unsigned int dpOutput = 0;
    unsigned int singleCh = 0;

    while((ch=getopt(argc, argv, "adhsv")) != -1)
    {
        switch(ch)
        {
            case 'a':
                audioTest = 1;
                break;
            case 'd':
                dpOutput = 1;
                break;
            case 'h':
                hdmiOutput = 1;
                break;
            case 'v':
                videoTest = 1;
                break;
            case 's':
                singleCh = 1;
                break;
            default:
				printUsage();
                return 0;
                break;
        }
    }
    
	if (argv[optind])
        filename = strdup(argv[optind]);
	else
	{
        printUsage();
		return 0;
	}

	printf("Play %s\n",filename);

	/* Initialize */
    rtk_serv_initialize();

    if(hdmiOutput && dpOutput)
        rtk_disp_set_output(HDMI_1080P_60, DP_1080P_60);
    else if(dpOutput)
        rtk_disp_set_output(HDMI_NONE, DP_1080P_60);
    else
        rtk_disp_set_output(HDMI_1080P_60, DP_NONE);

    channelID[0] = rtk_dec_add_channel();
    if(!singleCh)
    {
        channelID[1] = rtk_dec_add_channel();
        channelID[2] = rtk_dec_add_channel();
        channelID[3] = rtk_dec_add_channel();
        channelID[4] = rtk_dec_add_channel();
        channelID[5] = rtk_dec_add_channel();
        channelID[6] = rtk_dec_add_channel();
        channelID[7] = rtk_dec_add_channel();
        channelID[8] = rtk_dec_add_channel();
    }
    /* Set the URI to play */
    //multaudio.mp4:720p 24fps(h264+aac)
    //720p.mp4:720p 30fps(h264+aac)
    rtk_dec_open(channelID[0], filename);
    if(!singleCh)
    {
        rtk_dec_open(channelID[1], filename);
        rtk_dec_open(channelID[2], filename);
        rtk_dec_open(channelID[3], filename);
        rtk_dec_open(channelID[4], filename);
        rtk_dec_open(channelID[5], filename);
        rtk_dec_open(channelID[6], filename);
        rtk_dec_open(channelID[7], filename);
        rtk_dec_open(channelID[8], filename);
    }

    wndlID[0] = rtk_disp_create(0, 0, 640, 360);
    if(!singleCh)
    {
        wndlID[1] = rtk_disp_create(0, 360, 640, 360);
        wndlID[2] = rtk_disp_create(0, 720, 640, 360);
        wndlID[3] = rtk_disp_create(640, 0, 640, 360);
        wndlID[4] = rtk_disp_create(640, 360, 640, 360);
        wndlID[5] = rtk_disp_create(640, 720, 640, 360);
        wndlID[6] = rtk_disp_create(1280, 0, 640, 360);
        wndlID[7] = rtk_disp_create(1280, 360, 640, 360);
        wndlID[8] = rtk_disp_create(1280, 720, 640, 360);
    }

    rtk_dec_bind(channelID[0], wndlID[0]);
    if(!singleCh)
    {
        rtk_dec_bind(channelID[1], wndlID[1]);
        rtk_dec_bind(channelID[2], wndlID[2]);
        rtk_dec_bind(channelID[3], wndlID[3]);
        rtk_dec_bind(channelID[4], wndlID[4]);
        rtk_dec_bind(channelID[5], wndlID[5]);
        rtk_dec_bind(channelID[6], wndlID[6]);
        rtk_dec_bind(channelID[7], wndlID[7]);
        rtk_dec_bind(channelID[8], wndlID[8]);
    }

    /* Start playing */
    rtk_dec_set_play(CH_STATE_PLAY, channelID[0]);
	sleep(5);
    if(!singleCh)
    {
        rtk_dec_set_play(CH_STATE_PLAY, channelID[1]);
        sleep(5);
        rtk_dec_set_play(CH_STATE_PLAY, channelID[2]);
        sleep(5);
        rtk_dec_set_play(CH_STATE_PLAY, channelID[3]);
        sleep(5);
        rtk_dec_set_play(CH_STATE_PLAY, channelID[4]);
        sleep(5);
        rtk_dec_set_play(CH_STATE_PLAY, channelID[5]);
        sleep(5);
        rtk_dec_set_play(CH_STATE_PLAY, channelID[6]);
        sleep(5);
        rtk_dec_set_play(CH_STATE_PLAY, channelID[7]);
        sleep(5);
        rtk_dec_set_play(CH_STATE_PLAY, channelID[8]);
        sleep(5);
    }

    if(audioTest)
    {
        rtk_dec_start_audio(channelID[0]);
        sleep(25);
        rtk_dec_stop_audio(channelID[0]);
        sleep(5);

        rtk_dec_start_audio(channelID[0]);
        sleep(25);
        rtk_dec_stop_audio(channelID[0]);
        sleep(5);

        if(!singleCh)
        {
            rtk_dec_start_audio(channelID[6]);
            sleep(20);
            rtk_dec_set_mute(true, channelID[6]);//mute on
            sleep(10);
            rtk_dec_set_mute(false, channelID[6]);//mute off
            sleep(10);
            rtk_dec_set_volume(5.0f, channelID[6]);//set volume
            sleep(20);
            rtk_dec_increase_volume(channelID[6]);//increase 0.5f each time
            sleep(5);
            rtk_dec_get_volume(channelID[6], &volume);
            printf ("audio volume: %lf ! \n", volume);
            sleep(2);
            rtk_dec_increase_volume(channelID[6]);
            sleep(5);
            rtk_dec_increase_volume(channelID[6]);
            sleep(5);
            rtk_dec_get_volume(channelID[6], &volume);
            printf ("audio volume: %lf ! \n", volume);
            sleep(2);
            rtk_dec_increase_volume(channelID[6]);
            sleep(5);
            rtk_dec_decrease_volume(channelID[6]);//decrease 0.5f each time
            sleep(5);
            rtk_dec_decrease_volume(channelID[6]);
            sleep(5);
            rtk_dec_get_volume(channelID[6], &volume);
            printf ("audio volume: %lf ! \n", volume);
            sleep(2);
            rtk_dec_decrease_volume(channelID[6]);
            sleep(5);
            rtk_dec_decrease_volume(channelID[6]);
            sleep(5);
            rtk_dec_set_volume(1.0f, channelID[6]);//set volume
            sleep(20);
            rtk_dec_decrease_volume(channelID[6]);
            sleep(5);
            rtk_dec_get_volume(channelID[6], &volume);
            printf ("audio volume: %lf ! \n", volume);
            sleep(2);
            sleep(10);
            rtk_dec_stop_audio(channelID[6]);
            sleep(5);
        }
    }

    if(videoTest && (!singleCh))
    {
        //blank test
        printf("blank test...\n");
        rtk_disp_set_blank(1, 5, wndlID[0], wndlID[2], wndlID[4],
                   wndlID[6], wndlID[8]);
        sleep(15);
        rtk_disp_set_blank(0, 5, wndlID[0], wndlID[2], wndlID[4],
                   channelID[6], wndlID[8]);
        rtk_disp_set_blank(1, 4, wndlID[1], wndlID[3], wndlID[5],
                   wndlID[7]);
        sleep(15);
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

        //printf("snapshot test...\n");
        //rtk_snapshot_display("/tmp/snapshot.jpg");

    }


    sleep(100);

	if(singleCh)
		rtk_disp_set_blank(1, 1, wndlID[0]);
	else
		rtk_disp_set_blank(1, 9, wndlID[0], wndlID[1], wndlID[2], wndlID[3],
				    wndlID[4], wndlID[5], wndlID[6], wndlID[7], wndlID[8]);

	sleep(10);

    rtk_disp_destroy(wndlID[0]);
    if(!singleCh)
    {
        rtk_disp_destroy(wndlID[1]);
        rtk_disp_destroy(wndlID[2]);
        rtk_disp_destroy(wndlID[3]);
        rtk_disp_destroy(wndlID[4]);
        rtk_disp_destroy(wndlID[5]);
        rtk_disp_destroy(wndlID[6]);
        rtk_disp_destroy(wndlID[7]);
        rtk_disp_destroy(wndlID[8]);
    }

    sleep(1);

    rtk_dec_set_play(CH_STATE_STOP, channelID[0]);
    if(!singleCh)
    {
        rtk_dec_set_play(CH_STATE_STOP, channelID[1]);
        rtk_dec_set_play(CH_STATE_STOP, channelID[2]);
        rtk_dec_set_play(CH_STATE_STOP, channelID[3]);
        rtk_dec_set_play(CH_STATE_STOP, channelID[4]);
        rtk_dec_set_play(CH_STATE_STOP, channelID[5]);
        rtk_dec_set_play(CH_STATE_STOP, channelID[6]);
        rtk_dec_set_play(CH_STATE_STOP, channelID[7]);
        rtk_dec_set_play(CH_STATE_STOP, channelID[8]);
    }

    rtk_dec_remove_channel(channelID[0]);
    if(!singleCh)
    {
        rtk_dec_remove_channel(channelID[1]);
        rtk_dec_remove_channel(channelID[2]);
        rtk_dec_remove_channel(channelID[3]);
        rtk_dec_remove_channel(channelID[4]);
        rtk_dec_remove_channel(channelID[5]);
        rtk_dec_remove_channel(channelID[6]);
        rtk_dec_remove_channel(channelID[7]);
        rtk_dec_remove_channel(channelID[8]);
    }

    sleep(1);

	free(filename);
    /* Terminate */
    rtk_serv_terminate();
    return 0;
}
