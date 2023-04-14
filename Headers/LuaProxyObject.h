#import <objc/runtime.h>
#import <objc/message.h>

@interface LuaProxyObject : NSProxy{
    Protocol *col;
    lua_State *L;
    int envRef;
    int8_t ret[16];
}

@property (nonatomic, strong) NSString *lastLuaErrorMessage;

- (BOOL) hasLuaError;

- (id) initWithProtocol: (Protocol *) value withLuaState: (lua_State *) al withEnv: (int) ref;

@end
