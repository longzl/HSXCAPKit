#ifndef LUACV_COREPP
#define LUACV_COREPP

#include "opencv2/opencv.hpp"
#include "luacvaux.h"
#include "lua_core.h"

#include  "Mat.h"

#define COREPP_NAME LIBNAME"_corepp"



#define coreppReg()\
  objectReg(MAT_NAME,Mat_m);\

extern const luaL_Reg corepp[];
extern const luacv_var corepp_var[];
extern const luacv_var corepp_object[];

extern "C" {
#if defined(WIN32) || defined(WIN64)
__declspec(dllexport) 
#endif
int luaopen_luacv_corepp(lua_State *L);
}

#endif
