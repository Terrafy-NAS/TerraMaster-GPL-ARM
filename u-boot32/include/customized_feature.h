#ifndef __CUSTOMIZED_FEATURE_H_
#define __CUSTOMIZED_FEATURE_H_	

#define REG32( addr )		  (*(volatile uint32_t *)(addr))

enum RTK_DTB_PATH {
     RTK_DTB_PATH_DEFAULT = 0,
     RTK_DTB_PATH_FB = 1,
     RTK_DTB_PATH_MAX = 2,
};

#endif	/* __CUSTOMIZED_FEATURE_H_ */
