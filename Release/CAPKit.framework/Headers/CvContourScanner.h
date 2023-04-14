#ifndef CVCONTOURSCANNER_NAME
#include "opencv2/opencv.hpp"
#include "luacvaux.h"

#define CVCONTOURSCANNER_NAME "CvContourScanner"

#define checkCvContourScanner(L,i) luacv_checkObject<CvContourScanner>(L,i,CVCONTOURSCANNER_NAME)
void pushCvContourScanner(lua_State *L,CvContourScanner *);


extern const struct luaL_Reg CvContourScanner_m[];
#endif
