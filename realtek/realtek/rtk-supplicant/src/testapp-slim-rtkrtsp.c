#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <ctype.h>
#include <sys/stat.h>
#include <sys/types.h>
#include <libgen.h>
#include <signal.h>

#include "rtkcontrol.h"
#include "rtkrtsp.h"

#define PLAYER_NUM	32

#define HLS_TARGETDURATION	6

#define CHECK(x) do {                                                     \
        if (x != RTK_SUCCESS) {                                         \
            printf("err on line %d\n", __LINE__);           \
        }                                                                 \
    } while (0)

ChannelId channelID[PLAYER_NUM] = {-1};
WindowId wndlID[PLAYER_NUM] = {-1};

typedef struct channelPos
{
    unsigned int x;
    unsigned int y;
    unsigned int width;
    unsigned int height;
}channelPos;

channelPos chTbl_1[1] =
{
    {0, 0, 1920, 1080},
};

channelPos chTbl_4[4] =
{
    {0, 0, 960, 540},
    {0, 540, 960, 540},
    {960, 0, 960, 540},
    {960, 540, 960, 540},
};


channelPos chTbl_9[9] =
{
    {0, 0, 640, 360},
    {0, 360, 640, 360},
    {0, 720, 640, 360},
    {640, 0, 640, 360},
    {640, 360, 640, 360},
    {640, 720, 640, 360},
    {1280, 0, 640, 360},
    {1280, 360, 640, 360},
    {1280, 720, 640, 360},
};


channelPos chTbl_16[16] =
{
    {0, 0, 480, 270},
    {0, 270, 480, 270},
    {0, 540, 480, 270},
    {0, 810, 480, 270},
    {480, 0, 480, 270},
    {480, 270, 480, 270},
    {480, 540, 480, 270},
    {480, 810, 480, 270},
    {960, 0, 480, 270},
    {960, 270, 480, 270},
    {960, 540, 480, 270},
    {960, 810, 480, 270},
    {1440, 0, 480, 270},
    {1440, 270, 480, 270},
    {1440, 540, 480, 270},
    {1440, 810, 480, 270},
};

channelPos chTbl_32[32] =
{
#if 0
    {0, 0, 640, 360},
    {0, 360, 640, 360},
    {0, 720, 640, 360},
    {0, 1080, 640, 360},
    {0, 1440, 640, 360},
    {0, 1800, 640, 360},

    {640, 0, 640, 360},
    {640, 360, 640, 360},
    {640, 720, 640, 360},
    {640, 1080, 640, 360},
    {640, 1440, 640, 360},
    {640, 1800, 640, 360},

    {1280, 0, 640, 360},
    {1280, 360, 640, 360},
    {1280, 720, 640, 360},
    {1280, 1080, 640, 360},
    {1280, 1440, 640, 360},
    {1280, 1800, 640, 360},

    {1920, 0, 640, 360},
    {1920, 360, 640, 360},
    {1920, 720, 640, 360},
    {1920, 1080, 640, 360},
    {1920, 1440, 640, 360},
    {1920, 1800, 640, 360},

    {2560, 0, 640, 360},
    {2560, 360, 640, 360},
    {2560, 720, 640, 360},
    {2560, 1080, 640, 360},
    {2560, 1440, 640, 360},
    {2560, 1800, 640, 360},

    {3200, 0, 640, 360},
    {3200, 360, 640, 360},
#else
    {0, 0, 1088, 616},
    {0, 616, 1088, 616},
    {0, 1232, 544, 308},
    {0, 1540, 544, 308},
    {0, 1848, 544, 308},
    {544, 1232, 544, 308},

    {544, 1540, 544, 308},
    {544, 1848, 544, 308},
    {1088, 0, 1088, 616},
    {1088, 616, 1632, 924},
    {1088, 1540, 544, 308},
    {1088, 1848, 544, 308},

    {1632, 1540, 544, 308},
    {1632, 1848, 544, 308},
    {2176, 0, 544, 308},
    {2176, 308, 544, 308},
    {2176, 1540, 544, 308},
    {2176, 1848, 544, 308},

    {2720, 0, 544, 308},
    {2720, 308, 544, 308},
    {2720, 616, 544, 308},
    {2720, 924, 544, 308},
    {2720, 1232, 544, 308},
    {2720, 1540, 544, 308},

    {2720, 1848, 544, 308},
    {3264, 0, 544, 308},
    {3264, 308, 544, 308},
    {3264, 616, 544, 308},
    {3264, 924, 544, 308},
    {3264, 1232, 544, 308},

    {3264, 1540, 544, 308},
    {3264, 1848, 544, 308},
#endif
};

int gSigDone = 0;

static void sig_handler(int sig)
{
    gSigDone = 1;
}

void printUsage(void)
{
    printf("Usage: ./testapp-slim-rtkrtsp <rtsp://IPaddress:port/stream> [h264/h265] [/path/to/rec] [Number of Windows(1~%d, default 1)]\n", PLAYER_NUM);
    printf("Example: ./testapp-slim-rtkrtsp rtsp://192.168.0.188:43794/profile1 h265 /home/rec 4\n");
    printf("Example: ./testapp-slim-rtkrtsp rtsp://192.168.0.188:43794/profile1 h264 7\n");
}

RtkReturn_e start_nvr(int num, Stream codec)
{
    RtkReturn_e ret = RTK_SUCCESS;
    int i;
    ChannelParams_t param = {0};
    channelPos *pChTbl;

    if(num == 1)
        pChTbl = chTbl_1;
    else if(num > 1 && num<=4)
        pChTbl = chTbl_4;
    else if(num > 4 && num<=9)
        pChTbl = chTbl_9;
    else if(num > 9 && num<=16)
        pChTbl = chTbl_16;
    else if(num > 16 && num<=32)
        pChTbl = chTbl_32;

    for (i = 0; i < num; i++) {
        channelID[i] = rtk_dec_add_channel_video(-1, -1);
        wndlID[i] = rtk_disp_create(pChTbl[i].x, pChTbl[i].y, pChTbl[i].width, pChTbl[i].height, INPUT_STREAM_LIVE);
        if(codec==ES_H265)
            param.vid_codec = VIDEO_H265;
        else if(codec==ES_H264)
             param.vid_codec = VIDEO_H264;
        else
            param.vid_codec = VIDEO_MPEG4;

        rtk_dec_set_channel_video(channelID[i], &param);
        if(channelID[i]>=0 && wndlID[i]>=0)
        {
            if(rtk_dec_bind(channelID[i], wndlID[i]) != RTK_SUCCESS)
                ret |= RTK_ERR_FAILURE;

            if(rtk_dec_set_play(CH_STATE_PLAY, channelID[i]) != RTK_SUCCESS)
            {
                printf("set play fail\n");
                ret = rtk_dec_set_play(CH_STATE_STOP, channelID[i]);
                CHECK(ret);
                ret |= RTK_ERR_FAILURE;
            }
        }
        else
            ret |= RTK_ERR_FAILURE;
    }

    return ret;
}

int stop_nvr(int num)
{
    int i;
    RtkReturn_e ret = RTK_SUCCESS;

    for (i = 0; i < num; i++)
    {
        if(wndlID[i]>=0)
        {
            ret = rtk_disp_destroy(wndlID[i]);
            CHECK(ret);
        }

        if(channelID[i]>=0)
        {
            ret = rtk_dec_set_play(CH_STATE_STOP, channelID[i]);
            CHECK(ret);

            ret = rtk_dec_remove_channel(channelID[i]);
            CHECK(ret);
        }
    }

    //blank all
    ret = rtk_disp_set_blank(1, 1, -1);
    CHECK(ret);

    /* Terminate */
    rtk_serv_terminate();
    return 0;
}

int main(int argc, char **argv)
{
    struct sigaction newact;
    RtspPlayer *players[PLAYER_NUM];
    char *url = NULL;
    char path[80], *dirc;
    int i;
    int number = 1;
    int key;
    time_t now;
    struct tm *tm;
    char tstr[16];
    RtkReturn_e ret = RTK_SUCCESS;
    Stream codec = ES_H264;

    if (argc < 3) {
        printUsage();
        return 1;
    }

     if((strcmp(argv[2], "h264") == 0)){
        codec = ES_H264;}
     else if((strcmp(argv[2], "h265") == 0)){
        codec = ES_H265;}
     else if((strcmp(argv[2], "mpeg4") == 0))
     {
        codec = ES_MPEG4;
     }
     else
     {
        printUsage();
        return 1;
     }

    newact.sa_handler = (__sighandler_t)sig_handler;
    sigemptyset(&newact.sa_mask);
    newact.sa_flags = 0;
    sigaction(SIGSEGV, &newact, NULL);
    sigaction(SIGILL, &newact, NULL);
    sigaction(SIGABRT, &newact, NULL);
    sigaction(SIGBUS, &newact, NULL);
    sigaction(SIGTERM, &newact, NULL);
    sigaction(SIGKILL, &newact, NULL);
    sigaction(SIGINT, &newact, NULL);
    sigaction(SIGHUP, &newact, NULL);

    url = argv[1];

    /* Initialize */
    ret = rtk_serv_initialize();
    if(ret != RTK_SUCCESS)
    {
        printf("initialize error\n");
        rtk_serv_force_terminate();
        ret = rtk_serv_initialize();
        if(ret != RTK_SUCCESS)
        {
            printf("renitialize error\n");
            return 0;
        }
    }

    if((argc == 4 && (argv[3][0] >='0') && (argv[3][0] <='9')) || (argc == 5 && (argv[4][0] >='0') && (argv[4][0] <='9')))
    {
        if(argc == 4)
            number = atoi(argv[3]);
        else if(argc == 5)
            number = atoi(argv[4]);

        if(number <= 0 || number > PLAYER_NUM )
        {
            printf("Only support 1~%d windows, reset to 1 window\n", PLAYER_NUM);
            number = 1;
        }
    }

    memset(channelID, 0, sizeof(channelID));
    memset(wndlID, 0, sizeof(wndlID));

    ret = start_nvr(number, codec);
    if(ret != RTK_SUCCESS)
    {
        printf("start nvr fail\n");
        goto fail;
    }
    sleep(1);

    for (i = 0; i < number; i++)
    	players[i] = rtsp_player_new(url, channelID[i]);

    /* Do recording */
    if((argc == 4 && ((argv[3][0] < '0') || (argv[3][0] > '9'))) || (argc == 5)) {
	now = time(NULL);
	tm = localtime(&now);
	strftime(tstr, sizeof(tstr), "%Y%m%d_%H%M%S", tm);

	for (i = 0; i < number; i++) {
	    memset(path, 0, sizeof(path));
	    sprintf(path, "%s/%d/%s", argv[3], i, tstr);
	    dirc = strdup(path);
	    mkdir(dirname(dirc), 0755);
	    mkdir(path, 0755);
	    free(dirc);

	    rtsp_player_rec_start(players[i], path, HLS_TARGETDURATION);
	}
    }

    for (i = 0; i < number; i++)
    {
        rtsp_player_set_stream(players[i], codec);
        rtsp_player_play(players[i]);
    }

    do {
	printf
	    ("Press 'q' to quit program, 'h' to start HLS, 'x' to stop HLS, 'c' to change HLS.\n");
	fflush(stdout);

	if (key == 'h') {
	    if (argc > 2) {
		now = time(NULL);
		tm = localtime(&now);
		strftime(tstr, sizeof(tstr), "%Y%m%d_%H%M%S", tm);

		for (i = 0; i < number; i++) {
		    memset(path, 0, sizeof(path));
		    sprintf(path, "%s/%d/%s", argv[3], i, tstr);
		    dirc = strdup(path);
		    mkdir(dirname(dirc), 0755);
		    mkdir(path, 0755);
		    free(dirc);

		    rtsp_player_rec_start(players[i], path, HLS_TARGETDURATION);
		}
	    } else
		printf("ERROR: No path\n");
	} else if (key == 'x') {
	    for (i = 0; i < number; i++) {
		rtsp_player_rec_stop(players[i]);
	    }
	} else if (key == 'c') {
	    if (argc > 2) {
		now = time(NULL);
		tm = localtime(&now);
		strftime(tstr, sizeof(tstr), "%Y%m%d_%H%M%S", tm);

		for (i = 0; i < number; i++) {
		    memset(path, 0, sizeof(path));
		    sprintf(path, "%s/%d/%s", argv[3], i, tstr);
		    dirc = strdup(path);
		    mkdir(dirname(dirc), 0755);
		    mkdir(path, 0755);
		    free(dirc);

		    rtsp_player_rec_change(players[i], path, HLS_TARGETDURATION);
		}
	    }
	}
    } while ((key = getchar()) != 'q' && !gSigDone);

    for (i = 0; i < number; i++)
	rtsp_player_stop(players[i]);

    for (i = 0; i < number; i++)
	rtsp_player_free(players[i]);
fail:
    stop_nvr(number);

    return 0;
}
