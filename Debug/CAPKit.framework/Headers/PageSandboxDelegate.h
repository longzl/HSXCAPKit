@class CAPPageSandbox;

@protocol PageSandboxDelegate <NSObject>

- (void) onFronted: (CAPPageSandbox *) sandbox;
- (void) onIdle: (CAPPageSandbox *) sandbox;

@end

