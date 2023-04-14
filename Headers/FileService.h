#import <CAPKit/CAPKit.h>

@interface FileService : AbstractLuaTableCompatible <IService, LuaTableCompatible> {
    lua_State *L;
}

- (LuaData *) load: (NSString *) path;

@end
