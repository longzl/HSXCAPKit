#define IGNORE_VALUE [NSNull null]

@protocol LuaTableCompatible <NSObject>

@optional

- (LuaTable *) toLuaTable;

- (BOOL) newIndex: (NSObject *) key withValue: (NSObject *) value;

- (NSObject *) index: (NSObject *) key;

- (void) __gc;

- (void) setCurrentState: (lua_State *) L;

@end
