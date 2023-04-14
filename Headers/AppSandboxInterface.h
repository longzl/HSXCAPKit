@protocol AppSandboxInterface <DefaultSandboxInterface>

- (void) eval: (NSString *) script;

- (BOOL) call: (NSString *) func : (NSArray *) arguments : (LuaFunction *) callback;

- (NSString *) getLoadModel;

- (NSString *) _LUA_resolveFile: (NSString *) path;

- (NSNumber *) getScale;

- (NSNumber *) getFontScale;

@end
