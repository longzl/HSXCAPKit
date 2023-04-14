#ifndef caplua_h
#define caplua_h

#include "utlua.h"

lua_State* utlua_open_state();
int caplua_resume(lua_State *co, lua_State *from, int count);

LUALIB_API int secure_loadfile (lua_State *L, const char *filename,
                                const char *mode);

#endif
