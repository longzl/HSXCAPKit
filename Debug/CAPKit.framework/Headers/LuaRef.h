@interface LuaRef : NSObject{
    lua_State *L;
}

@property (nonatomic, readonly) int ref;

#ifdef DEBUG_EOS
@property (nonatomic, strong) NSString *appId;
#endif

- (id)initWithRef: (int) value withState: (lua_State *) st;

- (void) unref;

- (BOOL) isValid;

- (lua_State *) getState;

@end
