#ifndef CVLSHOPERATIONS_NAME
#include "opencv2/opencv.hpp"
#include "luacvaux.h"

#define CVLSHOPERATIONS_NAME "CvLSHOperations"

#define checkCvLSHOperations(L,i) luacv_checkObject<CvLSHOperations>(L,i,CVLSHOPERATIONS_NAME)
void pushCvLSHOperations(lua_State *L,CvLSHOperations *);


extern const struct luaL_Reg CvLSHOperations_m[];
#endif
