#ifndef LUACV_CALIB3D
#define LUACV_CALIB3D

#include "opencv2/opencv.hpp"
#include "luacvaux.h"
#include "lua_core.h"

#include "CvPOSITObject.h"
#include "CvStereoBMState.h"

#define CALIB3D_NAME LIBNAME"_calib3d"

#define calib3dReg()\
  objectReg(CVPOSITOBJECT_NAME,CvPOSITObject_m);\
  objectReg(CVSTEREOBMSTATE_NAME,CvStereoBMState_m);\


extern const luaL_Reg calib3d[];
extern const luacv_var calib3d_var[];
extern const luacv_var calib3d_object[];

extern "C" {
#if defined(WIN32) || defined(WIN64)
__declspec(dllexport) 
#endif
int luaopen_luacv_calib3d(lua_State *L);
}
#endif
