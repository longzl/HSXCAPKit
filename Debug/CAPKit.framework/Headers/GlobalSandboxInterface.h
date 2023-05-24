@class CAPPageSandbox;
@class CAPAppSandbox;

@protocol GlobalSandboxInterface <DefaultSandboxInterface>

- (void) scanApps DEPRECATED_ATTRIBUTE;

- (NSArray *) listApps: (NSString *) category DEPRECATED_ATTRIBUTE;

- (CAPAppSandbox *) getAppSandbox: (NSString *) appId DEPRECATED_ATTRIBUTE;
- (CAPAppSandbox *) getAppSandboxById: (NSString *) appId DEPRECATED_ATTRIBUTE;

- (CAPPageSandbox *) getPageSandbox: (NSString *) appId :(NSString *) pageId DEPRECATED_ATTRIBUTE;
- (CAPPageSandbox *) getPageSandbox: (NSString *) appId DEPRECATED_ATTRIBUTE;

@end
