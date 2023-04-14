#import <AVFoundation/AVFoundation.h>
#import <CAPKit/CAPKit.h>

@interface BarcodeViewController : UIViewController

@property (nonatomic, weak) AVCaptureSession *session;
@property (nonatomic, weak) CAPViewWidget *overlay;


@end

@interface BarcodeService : AbstractLuaTableCompatible <IService, AVCaptureMetadataOutputObjectsDelegate> {
    AVCaptureSession * session;
    AVCaptureMetadataOutput *output;
    lua_State *L;
    CGRect scanCrop;
}

@property (nonatomic, strong) CAPViewWidget *overlay;
@property (nonatomic, strong) LuaFunction *callback;
@property (nonatomic, strong) BarcodeViewController *controller;

@property (nonatomic, readwrite) BOOL gbkEncoding;

- (void) scan: (LuaFunction *) callback;

@end
