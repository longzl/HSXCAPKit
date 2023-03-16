//
//  LocaleService.h
//  EOSFramework
//
//  Created by Sam on 5/27/13.
//
//

#import <Foundation/Foundation.h>
#import "IService.h"
#import "lua.h"
#import "LuaTableCompatible.h"

@interface LocaleService : NSObject <IService, LuaTableCompatible>{
    lua_State *L;
    LuaTable *tb;
}

@end
