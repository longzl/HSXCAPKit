#ifndef LUACV_LEGACY
#define LUACV_LEGACY
#include "opencv2/opencv.hpp"
#include "opencv2/legacy/legacy.hpp"
#include "opencv2/legacy/compat.hpp"

#include "luacvaux.h"
#include "lua_core.h"


#include "CvImgObsInfo.h"
#include "CvEHMM.h"
#include "CvContourTree.h"
#include "CvGLCM.h"
#include "CvFaceTracker.h"
#include "Cv3dTracker2dTrackedObject.h"
#include "Cv3dTrackerTrackedObject.h"
#include "CvStereoGCState.h"
#include "CvSURFPoint.h"
#include "CvSURFParams.h"
#include "CvMSERParams.h"
#include "CvStarKeypoint.h"
#include "CvStarDetectorParams.h"
#include "CvFeatureTree.h"
#include "CvLSH.h"
#include "CvLSHOperations.h"
#include "CvSubdiv2DEdge.h"
#include "CvSubdiv2D.h"
#include "CvQuadEdge2D.h"
#include "CvSubdiv2DPoint.h"
#include "CvBGStatModel.h"
#include "CvFGDStatModelParams.h"
#include "CvBGPixelCStatTable.h"
#include "CvBGPixelCCStatTable.h"
#include "CvBGPixelStat.h"
#include "CvFGDStatModel.h"
#include "CvGaussBGStatModelParams.h"
#include "CvGaussBGValues.h"
#include "CvGaussBGPoint.h"
#include "CvGaussBGModel.h"
#include "CvBGCodeBookElem.h"
#include "CvBGCodeBookModel.h"


#define LEGACY_NAME LIBNAME"_legacy"

#define legacyReg()\
  objectReg(CVIMGOBSINFO_NAME,CvImgObsInfo_m);\
  objectReg(CVEHMM_NAME,CvEHMM_m);\
  objectReg(CVCONTOURTREE_NAME,CvContourTree_m);\
  objectReg(CVGLCM_NAME,CvGLCM_m);\
  objectReg(CVFACETRACKER_NAME,CvFaceTracker_m);\
  objectReg(CV3DTRACKER2DTRACKEDOBJECT_NAME,Cv3dTracker2dTrackedObject_m);\
  objectReg(CV3DTRACKERTRACKEDOBJECT_NAME,Cv3dTrackerTrackedObject_m);\
  objectReg(CVSTEREOGCSTATE_NAME,CvStereoGCState_m);\
  objectReg(CVSURFPOINT_NAME,CvSURFPoint_m);\
  objectReg(CVSURFPARAMS_NAME,CvSURFParams_m);\
  objectReg(CVSTARKEYPOINT_NAME,CvStarKeypoint_m);\
  objectReg(CVSTARDETECTORPARAMS_NAME,CvStarDetectorParams_m);\
  objectReg(CVFEATURETREE_NAME,CvFeatureTree_m);\
  objectReg(CVLSH_NAME,CvLSH_m);\
  objectReg(CVLSHOPERATIONS_NAME,CvLSHOperations_m);\
  objectReg(CVSUBDIV2DEDGE_NAME,CvSubdiv2DEdge_m);\
  objectReg(CVSUBDIV2DPOINT_NAME,CvSubdiv2DPoint_m);\
  objectReg(CVSUBDIV2D_NAME,CvSubdiv2D_m);\
  objectReg(CVQUADEDGE2D_NAME,CvQuadEdge2D_m);\
  objectReg(CVBGSTATMODEL_NAME,CvBGStatModel_m);\
  objectReg(CVFGDSTATMODELPARAMS_NAME,CvFGDStatModelParams_m);\
  objectReg(CVBGPIXELCSTATTABLE_NAME,CvBGPixelCStatTable_m);\
  objectReg(CVBGPIXELCCSTATTABLE_NAME,CvBGPixelCCStatTable_m);\
  objectReg(CVBGPIXELSTAT_NAME,CvBGPixelStat_m);\
  objectReg(CVFGDSTATMODEL_NAME,CvFGDStatModel_m);\
  objectReg(CVGAUSSBGSTATMODELPARAMS_NAME,CvGaussBGStatModelParams_m);\
  objectReg(CVGAUSSBGVALUES_NAME,CvGaussBGValues_m);\
  objectReg(CVGAUSSBGPOINT_NAME,CvGaussBGPoint_m);\
  objectReg(CVGAUSSBGMODEL_NAME,CvGaussBGModel_m);\
  objectReg(CVBGCODEBOOKELEM_NAME,CvBGCodeBookElem_m);\
  objectReg(CVBGCODEBOOKMODEL_NAME,CvBGCodeBookModel_m);
  //objectReg(CVMSERPARAMS_NAME,CvMSERParams_m);

extern const luaL_Reg legacy[];
extern const luacv_var legacy_var[];
extern const luacv_var legacy_object[];

extern "C" {
#if defined(WIN32) || defined(WIN64)
__declspec(dllexport) 
#endif
int luaopen_luacv_legacy(lua_State *L);
}

#endif
