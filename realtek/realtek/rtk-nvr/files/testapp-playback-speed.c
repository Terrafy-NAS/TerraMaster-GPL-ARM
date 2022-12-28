#include <stdio.h>
#include <string.h>
#include <unistd.h>

#include "rtkcontrol.h"

// set 1 to enable, default is 0 as disabled
int debuglevel = 1;

int main(int argc, const char **argv)
{
    ChannelId channelID[9];
    WindowId wndlID[9];
#ifdef MULTI
    double volume;
#endif
    char *filename = NULL;

    if (argc > 1)
    filename = strdup(argv[1]);
    else
    filename = strdup("/root/nfs/Testfiles/mp4/720p.mp4");

    printf("Play %s\n", filename);

    /* Initialize */
    rtk_serv_initialize();

    channelID[0] = rtk_dec_add_channel();
    channelID[1] = rtk_dec_add_channel();
    channelID[2] = rtk_dec_add_channel();
    channelID[3] = rtk_dec_add_channel();

    /* Set the URI to play */
    //multaudio.mp4:720p 24fps(h264+aac)
    //720p.mp4:720p 30fps(h264+aac)
    rtk_dec_open(channelID[0], filename);
    rtk_dec_open(channelID[1], filename);
    rtk_dec_open(channelID[2], filename);
    rtk_dec_open(channelID[3], filename);

    wndlID[0] = rtk_disp_create(0, 0, 960, 540);
    wndlID[1] = rtk_disp_create(0, 540, 960, 540);
    wndlID[2] = rtk_disp_create(960, 0, 960, 540);
    wndlID[3] = rtk_disp_create(960, 540, 960, 540);

    rtk_dec_bind(channelID[0], wndlID[0]);
    rtk_dec_bind(channelID[1], wndlID[1]);
    rtk_dec_bind(channelID[2], wndlID[2]);
    rtk_dec_bind(channelID[3], wndlID[3]);

    /* Start playing */
    rtk_dec_set_play(CH_STATE_PLAY, channelID[0]);
    sleep(5);
    rtk_dec_set_play(CH_STATE_PLAY, channelID[1]);
    sleep(5);
    rtk_dec_set_play(CH_STATE_PLAY, channelID[2]);
    sleep(5);
    rtk_dec_set_play(CH_STATE_PLAY, channelID[3]);

    sleep(5);
    rtk_dec_seek(channelID[1], 60);
    sleep(5);
    rtk_dec_start_audio(channelID[0]);
    sleep(5);
    rtk_dec_speed(channelID[0], 2);

    sleep(100);



    //blank test
    rtk_disp_set_blank(1, 4, wndlID[0], wndlID[1], wndlID[2], wndlID[3]);
    sleep(1);


    rtk_disp_destroy(wndlID[0]);
    rtk_disp_destroy(wndlID[1]);
    rtk_disp_destroy(wndlID[2]);
    rtk_disp_destroy(wndlID[3]);


    rtk_dec_set_play(CH_STATE_STOP, channelID[0]);
    rtk_dec_set_play(CH_STATE_STOP, channelID[1]);
    rtk_dec_set_play(CH_STATE_STOP, channelID[2]);
    rtk_dec_set_play(CH_STATE_STOP, channelID[3]);

    rtk_dec_remove_channel(channelID[0]);
    rtk_dec_remove_channel(channelID[1]);
    rtk_dec_remove_channel(channelID[2]);
    rtk_dec_remove_channel(channelID[3]);

    sleep(1);

    /* Terminate */
    rtk_serv_terminate();

    return 0;
}
