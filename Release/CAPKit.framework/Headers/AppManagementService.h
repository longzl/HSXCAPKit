#define APPID_FRAMEWORK @"framework"

@interface AppManagementService : AbstractLuaTableCompatible <IService>{
    NSMutableDictionary *appPathsMap;
    NSMutableDictionary *manifestsMap;
    
    NSMutableDictionary *appSandboxMap;
}

@property (nonatomic, weak) GlobalSandbox *globalSandbox;

- (BOOL) _COROUTINE_installFile: (NSString *) filePath : (NSString *) appId;

- (void) scan;
- (BOOL) remove: (NSString *) appId;
- (BOOL) remove: (NSString *) appId :(BOOL) removeAll;

- (NSArray *) list: (NSString *) category;

- (NSString *) pathForApp: (NSString *) appId;

- (CAPAppSandbox *) getAppSandbox: (NSString *) appId;

- (CAPPageSandbox *) getPageSandbox: (NSString *) appId :(NSString *) pageId;
- (CAPPageSandbox *) getPageSandbox: (NSString *) appId;

@end
