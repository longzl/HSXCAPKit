@protocol AppLifecycle <NSObject>

- (void) onNew;
- (void) onPreloaded;
- (void) onDownloaded;
- (void) onUnpacked;
- (void) onReloaded;
- (void) onReady;

- (void) onInstalled;
- (void) onPatched: (NSString *) oldVersion;

- (NSDictionary *) skin_spec;
- (NSDictionary *) _skin_spec;

@end
