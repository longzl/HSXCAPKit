@class CAPAppSandbox;

@interface GlobalSandbox : DefaultSandbox <GlobalSandboxInterface>{
    NSMutableDictionary *pkgApps;
    NSMutableArray *pkgStrings;
    NSFileHandle *pkgFileHandle;
}

@property (nonatomic, weak, readonly) CAPContainer *container;

@property (nonatomic, strong) NSMutableDictionary *singletonServices;

@property (nonatomic, weak) id<GlobalSandboxDelegate> delegate;

- (id)initWithContainer: (CAPContainer *) cont;

- (NSString *) getSecureCode;

- (NSString *) getSessionId;

- (void) makeSafeMode;

- (void) preparePackage;

- (NSData *) resolveData: (NSString *) appId withPath: (NSString *) path;

- (void) clear;

@end
