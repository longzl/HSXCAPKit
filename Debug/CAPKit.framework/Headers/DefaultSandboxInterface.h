@protocol DefaultSandboxInterface <EOSMapInterface>
- (id) getAppSandbox;

- (id) getGlobalSandbox;

- (EOSMap *) getMap: (NSString *) key;

- (EOSList *) getList: (NSString *) key;

- (BOOL) put: (NSString *) key value: (NSObject *) value;

- (BOOL) remove: (NSString *) key;

- (NSObject *) get: (NSString *) key;

- (BOOL) clear;

- (EOSList *) keys;

- (EOSList *) values;

- (NSString *) tostring;

- (NSString *) getAppPath;

- (NSString *) getDataPath;

- (NSString *) getAppId;

- (NSString *) getAppVersion;

- (NSString *) getScopeId;

@end
