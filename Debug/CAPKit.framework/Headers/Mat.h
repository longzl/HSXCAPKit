#ifndef MAT_NAME
#include "opencv2/opencv.hpp"
#include "luacvaux.h"

#define MAT_NAME "Mat"
#define checkMat(L,i) luacv_checkObject<cv::Mat>(L,i,MAT_NAME)
#define pushMat(L,data) luacv_pushObject<cv::Mat>(L,data,MAT_NAME,false)

using namespace cv;
extern const struct luaL_Reg Mat_m[];
#endif
