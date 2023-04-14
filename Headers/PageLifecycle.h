@protocol PageLifecycle <NSObject>

- (void) onNew;
- (void) onLoaded;
- (void) onCreated: (AppContext *) context;
- (void) onReady;
- (void) onFronted;
- (void) onIdle;
- (void) onTap;
- (void) onSwipeUp;
- (void) onSwipeDown;
- (void) onSwipeLeft;
- (void) onSwipeRight;
//- (void) onDestroy DEPRECATED_ATTRIBUTE;

- (void) onNavBack;
- (BOOL) shouldNavBack;

@end
