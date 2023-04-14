#ifndef  CVTERMCRITERIA_NAME 
#include "opencv2/opencv.hpp"
#include "luacvaux.h"

#define CVTERMCRITERIA_NAME "CvTermCriteria"

#define checkCvTermCriteria(L,i) luacv_checkObject<CvTermCriteria>(L,i,CVTERMCRITERIA_NAME)
#define pushCvTermCriteria(L,data) luacv_pushObject<CvTermCriteria>(L,data,CVTERMCRITERIA_NAME,true)

extern const struct luaL_Reg CvTermCriteria_m[];
#endif
