#ifndef __POWER_H__
#define __POWER_H__

#include <config.h>


#if defined(CONFIG_BOARD_QA_RTD1036)
	#include "power/power_rtd1036_qa.h"
#else
	#error "power-saving does not support this board."
#endif



#endif	// __POWER_H__

