@protocol ILuaReference <NSObject>

- (void) setRef: (int) value withRefState: (lua_State *) L;
- (int) getRef;

- (lua_State *) getRefState;

- (int) getEnvRef;

- (void) __gc;

@end
