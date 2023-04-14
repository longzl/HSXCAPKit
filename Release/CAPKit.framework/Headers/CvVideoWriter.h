#ifndef CVVIDEOWRITER_NAME
#include "opencv2/opencv.hpp"
#include "luacvaux.h"

#define CVVIDEOWRITER_NAME "CvVideoWriter"

#define checkCvVideoWriter(L,i) luacv_checkObject<CvVideoWriter>(L,i,CVVIDEOWRITER_NAME)
void pushCvVideoWriter(lua_State *L,CvVideoWriter *);

extern const struct luaL_Reg CvVideoWriter_m[];
#endif
