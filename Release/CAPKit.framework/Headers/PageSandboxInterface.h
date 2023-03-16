@protocol PageSandboxInterface <DefaultSandboxInterface>

- (NSString *) getPageId;

- (void) eval: (NSString *) script;

- (NSString *) _LUA_resolveFile: (NSString *) path;

- (NSNumber *) getScale;

- (NSNumber *) getFontScale;

@end
