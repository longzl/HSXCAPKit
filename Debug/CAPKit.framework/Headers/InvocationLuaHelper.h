#import <objc/runtime.h>

@interface InvocationHolder : NSObject

@property (nonatomic, assign) void *data;
@property (nonatomic, strong) id object;

+ (InvocationHolder *) holderWithPointer: (void *) p;
+ (InvocationHolder *) holderWithId: (id) obj;

@end

@interface InvocationLuaHelper : NSObject{
}

+ (void) pushInvocation: (NSInvocation *) invocation atIndex:(NSInteger)idx withLuaState: (lua_State *) L;

+ (InvocationHolder *) setInvocation: (NSInvocation *) invocation atIndex:(NSInteger)idx withLuaState: (lua_State *) L withIndex: (int) luaIndex;

+ (int) pushInvocationReturn: (NSInvocation *) invocation  withLuaState: (lua_State *) L;

+ (NSObject *) convertInvocationReturnToObject: (NSInvocation *) invocation;

+ (void) setInvocationReturn: (NSInvocation *) invocation withLuaState: (lua_State *) L withIndex: (int) idx;
@end
