#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <stdarg.h>

#include <unistd.h>
#include <netinet/in.h>
#include <sys/ioctl.h>
#include <sys/socket.h>
#include <arpa/inet.h>

#include <sys/types.h>
#include <sys/stat.h>
#include <signal.h>
#include <fcntl.h>
#include <errno.h>
#include <linux/wireless.h>

#include <time.h>

#include "pathsel_log.h"

FILE *gLogFile = NULL;
char gLogFileName[128];

void PathselLogInitFile(const char* fileName){
	strcpy(gLogFileName, fileName);
	if(fileName == NULL) {
		printf("%s Wrog File Name for Log FIle\n", __FUNCTION__);
	}

	if((gLogFile = fopen(fileName, "a+")) == NULL) {
		printf("%s Can't open log file: %s\n", __FUNCTION__, strerror(errno));
		exit(1);
	}
}

void PathselCloseFile() {
	fclose(gLogFile);
}

__inline__ void PathselLog(const char *format, ...) {
	char *logStr = NULL;
	va_list args;
	time_t now;
	char *nowReadable = NULL;

	now = time(NULL);
	nowReadable = ctime(&now);

	nowReadable[strlen(nowReadable)-1]='\0';

	PATHSEL_CREATE_STRING_ERR(logStr, (strlen(format)+strlen(nowReadable)+100), return;);

	sprintf(logStr, "[%s][Pathsel] %s\n", nowReadable, format);

	va_start(args, format);
				
	if(gLogFile != NULL) {
		char fileLine[256];
									
		vsnprintf(fileLine, 255, logStr, args);

		fwrite(fileLine, strlen(fileLine), 1, gLogFile);

		fflush(gLogFile);
	}
#ifdef WRITE_STD_OUTPUT	
	vprintf(logStr, args);
#endif
						
	va_end(args);
	PATHSEL_FREE_OBJECT(logStr);
}
