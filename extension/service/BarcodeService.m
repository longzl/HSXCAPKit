#import "BarcodeService.h"
#import <CAPKit/CAPKit.h>
#import <CAPKit/UIApplication+UIApplication_AppDimensions.h>

@implementation BarcodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    AVCaptureVideoPreviewLayer * layer = [AVCaptureVideoPreviewLayer layerWithSession: _session];
    layer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    layer.frame = self.view.layer.bounds;
    [self.view.layer insertSublayer:layer atIndex:0];

    if (_overlay) {
        CGSize size = self.view.frame.size;

        CGRect rect = [_overlay measureRect: [[_overlay.pageSandbox getAppSandbox].scale getRefSize: size]];
        [_overlay removeFromSuperview];

        _overlay->currentRect = CGRectMake(0, [UIApplication statusBarHeight], rect.size.width, rect.size.height);
        [_overlay reloadRect];

        [_overlay createView];
        [_overlay reLayoutChildren];
        [_overlay onFronted];

        [_overlay innerView].hidden = NO;

        [self.view addSubview: [_overlay innerView]];
    }
}

@end

@implementation BarcodeService

+(void)load{
    [[ESRegistry getInstance] registerService: @"BarcodeService" withName: @"barcode"];
}

-(BOOL)singleton{
    return NO;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _gbkEncoding = YES;
    }
    return self;
}

- (void) setCurrentState: (lua_State *) value{
    L = value;
}

- (void) setOverlay: (NSObject *) overlay{
    CAPViewWidget *widget = nil;
    if ([overlay isKindOfClass: [NSDictionary class]]) {
        CAPViewM *vm = (CAPViewM *)[ModelBuilder buildModel: (NSDictionary *) overlay];
        if (![vm isKindOfClass: [CAPViewM class]]) {
            return;
        }

        CAPPanelView<PagePanel> *panelView = [[OSUtils getContainerFromState: L].renderView topPanelView];
        CAPPageSandbox *sandbox = [panelView getSandbox];

        if (sandbox) {
            widget = (CAPViewWidget *)[WidgetBuilder buildWidget: vm withPageSandbox: sandbox];
        }
    }else if([overlay isKindOfClass: [CAPViewWidget class]]){
        widget = (CAPViewWidget *) overlay;
    }

    if ([widget isKindOfClass: [CAPViewWidget class]]) {
        _overlay = widget;
    }
}

- (void) cancel{
    [self cancel: nil];
}

- (void) cancel: (LuaFunction *) oncompleted{
    [OSUtils runBlockOnMain:^{
        [session stopRunning];

        [_controller dismissViewControllerAnimated: YES
                                        completion:^{
                                            if ([oncompleted isKindOfClass: [LuaFunction class]]) {
                                                [oncompleted executeWithoutReturnValue];
                                            }
                                            _controller = nil;
                                        }];
        _callback = nil;
    }];
}

- (void) take {
    NSLog(@"take not available for barcode service.");
}

- (void) addConfig:(NSString *)value {
    NSLog(@"addConfig not available for barcode service.");
}

- (void) removeAllConfig{
    NSLog(@"removeAllConfig not available for barcode service.");
}

-(void)onLoad{
    scanCrop = CGRectMake(0, 0, 1, 1);
}

- (void) setScanCrop: (NSNumber *) x :(NSNumber *) y :(NSNumber *) width :(NSNumber *) height{
    scanCrop = CGRectMake([x floatValue], [y floatValue], [width floatValue], [height floatValue]);
    scanCrop.origin.x = scanCrop.origin.x > 0.1 ? scanCrop.origin.x - 0.1 : 0;
    scanCrop.origin.y = scanCrop.origin.y > 0.1 ? scanCrop.origin.y - 0.1 : 0;
    scanCrop.size.width = scanCrop.origin.x + scanCrop.size.width < 0.9 ? scanCrop.size.width + 0.1 : 1;
    scanCrop.size.height = scanCrop.origin.y + scanCrop.size.height < 0.9 ? scanCrop.size.height + 0.1 : 1;
}

- (void) setGbk: (NSNumber *) value{
    _gbkEncoding = [value boolValue];
}

- (void) scan:(LuaFunction *)callback {
    [OSUtils runBlockOnMain:^{
        [self _scan: callback];
    }];
}

- (void) _scan: (LuaFunction *) callback{
    _callback = callback;

    if (!session) {
        session = [[AVCaptureSession alloc]init];
        [session setSessionPreset: AVCaptureSessionPresetHigh];

        AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType: AVMediaTypeVideo];
        AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice: device error:nil];
        if (!input) {
            NSLog(@"Can't find any Video Input Device.");
            _callback = nil;
            return;
        }
        [session addInput:input];

        output = [[AVCaptureMetadataOutput alloc] init];
        [output setMetadataObjectsDelegate: self queue: dispatch_get_main_queue()];

        [session addOutput:output];
//        NSLog(@"%@", [output availableMetadataObjectTypes]);
        output.metadataObjectTypes=@[AVMetadataObjectTypeQRCode,AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode128Code];

        dispatch_async(dispatch_get_main_queue(), ^{
            AVCaptureDevice *device = input.device;
            NSError *error = nil;
            if ([device lockForConfiguration:&error])
            {
                if ([device isFocusModeSupported: AVCaptureFocusModeContinuousAutoFocus])
                {
                    [device setFocusMode: AVCaptureFocusModeContinuousAutoFocus];
                }
                if ([device isExposureModeSupported: AVCaptureExposureModeContinuousAutoExposure])
                {
                    [device setExposureMode: AVCaptureExposureModeContinuousAutoExposure];
                }
                [device unlockForConfiguration];
            }
            else
            {
                NSLog(@"%@", error);
            }
        });

    }

//    if (!_controller) {
    _controller = [[BarcodeViewController alloc] init];
    _controller.session = session;
    _controller.overlay = _overlay;
//    }

//    CGRect cropRect = scanCrop;

//    CGSize size = self.view.bounds.size;
//    CGFloat p1 = size.height/size.width;
//    CGFloat p2 = 1920./1080.;  //使用了1080p的图像输出
//    if (p1 < p2) {
//        CGFloat fixHeight = bounds.size.width * 1920. / 1080.;
//        CGFloat fixPadding = (fixHeight - size.height)/2;
//        output.rectOfInterest = CGRectMake((cropRect.origin.y + fixPadding)/fixHeight,
//                                                  cropRect.origin.x/size.width,
//                                                  cropRect.size.height/fixHeight,
//                                                  cropRect.size.width/size.width);
//    } else {
//        CGFloat fixWidth = bounds.size.height * 1080. / 1920.;
//        CGFloat fixPadding = (fixWidth - size.width)/2;
//        output.rectOfInterest = CGRectMake(cropRect.origin.y/size.height,
//                                                  (cropRect.origin.x + fixPadding)/fixWidth,
//                                                  cropRect.size.height/size.height,
//                                                  cropRect.size.width/fixWidth);
//    }

    output.rectOfInterest = scanCrop;

    [session startRunning];

    // present and release the controller
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController: _controller
                                                                                 animated: YES
                                                                               completion:^{

                                                                               }];
}

-(void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects
      fromConnection:(AVCaptureConnection *)connection{
    if (metadataObjects.count > 0) {
        NSMutableArray *list = [NSMutableArray array];
        [list addObject: self];

        for (AVMetadataMachineReadableCodeObject *metadataObject in metadataObjects) {
            NSLog(@"%@",metadataObject.stringValue);

//            NSString *gbkstr;
//            if (_gbkEncoding) {
//                NSStringEncoding enc =CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
//                gbkstr = [NSString stringWithCString: metadataObject. encoding: enc];
//            }
            NSDictionary *dic = @{@"type": @"barcode", @"data": metadataObject.stringValue};
            [list addObject: dic];
        }

        LuaFunction *callback = _callback;

        [callback executeWithoutReturnValueWithArrayArguments: list];
        _callback = nil;

        [self cancel];
    }
}

@end
