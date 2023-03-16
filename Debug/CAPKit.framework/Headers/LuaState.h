#include <stdarg.h>
#include <stdio.h>
#include <stdlib.h>

@class DefaultSandbox;

@interface LuaState : LuaRef

- (lua_State*) state;

- (void) runBuffer: (NSString*)buf withEnv: (int) ref;
- (void) runData: (NSData*)buf withEnv: (int) ref;
- (void) runFileAtPath:(NSString*)filePath withEnv: (int) ref;

- (void) pushRegistyObject:(id)object withName:(const NSString*) key;
- (void) gc;

+ (void) exceptionAlert: (NSString *) message;

@end
