@protocol IService <NSObject>

- (BOOL) singleton;

@optional
- (void) onLoad;
- (void) onUnload;

@end
