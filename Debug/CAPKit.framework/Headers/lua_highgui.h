#ifndef LUACV_HIGHGUI

#define LUACV_HIGHGUI
#include "opencv2/opencv.hpp"
#include "luacvaux.h"

#include "lua_core.h"

#include "CvCapture.h"
#include "CvVideoWriter.h"

#define HIGHGUI_NAME LIBNAME"_highgui"

#define highguiReg()\
  objectReg(CVCAPTURE_NAME,CvCapture_m);\
  objectReg(CVVIDEOWRITER_NAME,CvVideoWriter_m);

extern luacv_callback *callbackTable[MAX_CALLBACKS];
extern const luaL_Reg highgui[];
extern const luacv_var highgui_var[];

extern "C" {
#if defined(WIN32) || defined(WIN64)
__declspec(dllexport) 
#endif
int luaopen_luacv_highgui(lua_State *L);
}

#endif
