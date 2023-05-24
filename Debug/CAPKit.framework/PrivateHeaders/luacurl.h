//
//  luacurl.h
//  EOSFramework
//
//  Created by Sam Chang on 2/20/12.
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#ifndef EOSLib2_luacurl_h
#define EOSLib2_luacurl_h
#include "lua.h"

#define LUACURL_API	extern

LUACURL_API int luaopen_luacurl (lua_State *L);

#endif
