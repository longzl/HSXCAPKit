#ifndef IPLIMAGE_NAME
#include "opencv2/opencv.hpp"
#include "luacvaux.h"
#include "IplTileInfo.h"
#include "IplROI.h"

#define IPLIMAGE_NAME "IplImage"

#define checkIplImage(L,i) luacv_checkObject<IplImage>(L,i,IPLIMAGE_NAME)
#define pushIplImage(L,data) luacv_pushObject<IplImage>(L,data,IPLIMAGE_NAME,false)

extern const struct luaL_Reg IplImage_m[];
#endif
