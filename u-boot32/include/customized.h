#ifndef __CUSTOMIZED_H_
#define __CUSTOMIZED_H_	

#include <customized_feature.h>

#define EXECUTE_CUSTOMIZED_FUNCTION	  	env_handler_customized("set Let env");
#define EXECUTE_CUSTOMIZED_FUNCTION_1 	({int __ret=0; __ret = detect_recovery_flag("Check Let Recovery"); __ret; })
#define EXECUTE_CUSTOMIZED_FUNCTION_2	rtk_plat_boot_prep_version();	
#define EXECUTE_CUSTOMIZED_FUNCTION_3(args...)	rtk_modify_dtb(args);					
										
void env_handler_customized(char *str);
int detect_recovery_flag(char *str);
int rtk_plat_boot_prep_version(void);
int rtk_modify_dtb(int type,enum RTK_DTB_PATH path,int target_addr,int size);





#endif	/* __CUSTOMIZED_H_ */
