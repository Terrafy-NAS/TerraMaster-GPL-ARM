#ifndef PATHSEL_LOG_H
#define PATHSEL_LOG_H

#include "common.h"

#include <time.h>
#include <sys/time.h>

#define	PATHSEL_CREATE_STRING_ERR(str_name, str_length, on_err)	do{(str_name) = (char*) (malloc(sizeof(char) * ((str_length)+1) ) ); if(!(str_name)) {on_err}}while(0)
#define	PATHSEL_FREE_OBJECT(obj_name)		do{if(obj_name){free((obj_name)); (obj_name) = NULL;}}while(0)

extern FILE *gLogFile;
extern char gLogFileName[];

void PathselLogInitFile(const char* fileName);
void PathselCloseFile();
__inline__ void PasthselLog(const char *format, ...);


#endif
