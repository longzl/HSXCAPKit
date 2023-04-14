#ifndef LUACV_VIDEO

#define LUACV_VIDEO
#include "opencv2/opencv.hpp"
#include "luacvaux.h"
#include "lua_core.h"
#include "lua_imgproc.h"

#include "CvKalman.h"
#define VIDEO_NAME LIBNAME"_video"

#define videoReg()\
  objectReg(CVKALMAN_NAME,CvKalman_m);\


extern const luaL_Reg video[];
extern const luacv_var video_var[];
extern const luacv_var video_object[];

extern "C" {
#if defined(WIN32) || defined(WIN64)
__declspec(dllexport) 
#endif
int luaopen_luacv_video(lua_State *L);
}

#endif
