#ifndef LUACV_IMGPROC

#define LUACV_IMGPROC

#include "opencv2/opencv.hpp"
#include "luacvaux.h"
#include "lua_core.h"
#include "lua_calib3d.h"

#include "CvMoments.h"
#include "CvHuMoments.h"
#include "CvConnectedComp.h"
#include "CvContourScanner.h"
#include "CvChainPtReader.h"

#define IMGPROC_NAME LIBNAME"_imgproc"

#define imgprocReg()\
  objectReg(CVMOMENTS_NAME,CvMoments_m);\
  objectReg(CVHUMOMENTS_NAME,CvHuMoments_m);\
  objectReg(CVCONNECTEDCOMP_NAME,CvConnectedComp_m);\
  objectReg(CVCONTOURSCANNER_NAME,CvContourScanner_m);\
  objectReg(CVCHAINPTREADER_NAME,CvChainPtReader_m);\


extern const luaL_Reg imgproc[];
extern const luacv_var imgproc_var[];
extern const luacv_var imgproc_object[];

extern "C" {
#if defined(WIN32) || defined(WIN64)
__declspec(dllexport) 
#endif
int luaopen_luacv_imgproc(lua_State *L);
}


#endif
