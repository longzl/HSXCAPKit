@interface LuaProxyBuilder : NSObject

+ (id) buildDelegateByProtocol: (Protocol *) col withLuaState: (lua_State *) L withEnv: (int) ref;

@end
