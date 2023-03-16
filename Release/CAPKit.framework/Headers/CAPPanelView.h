@class CAPPageSandbox;
@class CAPViewWidget;

@interface CAPPanelView : UIView <PagePanel, UIGestureRecognizerDelegate> {
    CGRect latestReloadFrame;
    
    BOOL tap_to_hide_keyboard;
    BOOL no_swipe;
    BOOL no_tap;

    UIStatusBarStyle statusBarStyle;
    BOOL statusBarHidden;

    UIStatusBarStyle lastStatusBarStyle;
    BOOL lastStatusBarHidden;

    dispatch_once_t created;
}

@property (nonatomic, strong, readonly) NSURL *pageURL;

@property (nonatomic, weak) CAPRenderView *renderView;

@property (nonatomic, strong, readonly, getter=getSandbox) CAPPageSandbox *sandbox;
@property (nonatomic, strong, readonly) CAPPageM *model;
@property (nonatomic, strong, readonly) CAPViewWidget *root;

@property (nonatomic, readonly) AppContext *context;

- (instancetype)initWithURL: (NSURL *) url withSandbox: (CAPPageSandbox *) sandbox;

- (void) reloadSize;

- (void) willOnFront;

@end
