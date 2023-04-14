#ifndef LUACV_FEATURES2D

#define LUACV_FEATURES2D
#include "opencv2/opencv.hpp"
#include "luacvaux.h"
#include "lua_core.h"

#define FEATURES2D_NAME LIBNAME"_features2d"

#define features2dReg()\


extern const luaL_Reg features2d[];
extern const luacv_var features2d_var[];
extern const luacv_var features2d_object[];

extern "C" {
#if defined(WIN32) || defined(WIN64)
__declspec(dllexport) 
#endif
int luaopen_luacv_features2d(lua_State *L);
}

#endif
