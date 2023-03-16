@class AppManagementService;
@class GlobalSandbox;

@interface ESRegistry : NSObject {
    NSMutableDictionary *services;
}

+ (ESRegistry *) getInstance;

+ (AppManagementService *) getAppManagementService:(lua_State *) L;
+ (AppManagementService *) getAppManagementService:(lua_State *) L
                                 withGlobalSandbox: (GlobalSandbox *) globalSandbox;

- (void) registerService: (NSString *) service withName: (NSString *) name;

- (NSObject<IService> *) getService: (NSString *) name DEPRECATED_ATTRIBUTE;
- (NSObject<IService> *) getService: (NSString *) name
                  withGlobalSandbox: (GlobalSandbox *) globalSandbox;
- (NSObject<IService> *) getService: (NSString *) name
                          withState: (lua_State *) L;

- (NSObject<IService> *) getService: (NSString *) name
                          withState: (lua_State *) L
                  withGlobalSandbox: (GlobalSandbox *) globalSandbox;

@end
