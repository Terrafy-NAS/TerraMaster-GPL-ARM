CFLAGS += `pkg-config --cflags --libs gstreamer-1.0`
GST_APP_CFLAGS = `pkg-config --cflags --libs gstreamer-1.0 gstreamer-app-1.0`

all:
	$(CC) -Wall -Werror -o testapp-playback testapp-playback.c -lrtkcontrol
	$(CC) -Wall -Werror -o testapp-filewrite-ch testapp-filewrite-ch.c testapp-utils.c -lrtkcontrol
	$(CC) -Wall -Werror -o testapp-filewrite-disp testapp-filewrite-disp.c testapp-utils.c -lrtkcontrol
	$(CC) -Wall -Werror -o testapp-filewrite-wnd testapp-filewrite-wnd.c testapp-utils.c -lrtkcontrol
	$(CC) -Wall -Werror -o testapp-rtspclient-disp testapp-rtspclient-disp.c testapp-utils.c -lrtkcontrol
	$(CC) $(CFLAGS) -Wall -Werror -L$(GENERIC_LINUX_PATH)/lib -o test-rtspclient test-rtspclient.c testapp-utils.c -lrtkcontrol
	$(CC) -Wall -Werror -o testapp-playback-speed testapp-playback-speed.c -lrtkcontrol
	$(CC) -Wall -Werror -o testapp-thumbnail testapp-thumbnail.c -lrtkstream $(GST_APP_CFLAGS)

