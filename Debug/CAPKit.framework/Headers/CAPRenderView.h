#import <CAPKit/CAPPanelView.h>

@class GlobalSandbox;

@interface CAPRenderView : UIView {
    NSMutableArray *stack;
    UIView *contentView;
}

@property (nonatomic, assign) CGRect rect;
@property (nonatomic, weak) GlobalSandbox *globalSandbox;
@property (nonatomic, assign) BOOL insideFrame;

- (void) reloadSize;

- (void) pushView: (CAPPanelView<PagePanel> *) view animated: (BOOL) animated;

- (void) popViewAnimated: (BOOL) animated;

- (void) popToView: (CAPPanelView<PagePanel> *) view animated: (BOOL) animated;

- (NSArray *) listAllPanelViews;

- (void) setPanelViews: (NSArray *) list animated: (BOOL) animated;

- (CAPPanelView *) topPanelView;

- (BOOL) switchApp: (AppContext *) context;
- (BOOL) switchPage: (AppContext *) context;
- (BOOL) pushApp: (AppContext *) context;
- (BOOL) popPage: (AppContext *) context;
- (BOOL) popApp: (AppContext *) context;
- (BOOL) popAndPushApp: (AppContext *) context;
- (void) reloadPage: (AppContext *) context;

- (BOOL) onNavBack;

@end
