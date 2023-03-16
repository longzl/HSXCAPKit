@class CAPAppSandbox;
@class CAPPageSandbox;
@protocol PagePanel;

@protocol GlobalSandboxDelegate <NSObject>

- (void) onAppSandboxCreated: (CAPAppSandbox *) sandbox;

- (void) onPageSandboxCreated: (CAPPageSandbox *) sandbox;

- (void) onPagePanelCreated: (id<PagePanel>) pagepanel;

@end
