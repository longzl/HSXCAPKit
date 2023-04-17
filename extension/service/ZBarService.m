#import "ZBarService.h"
#import "ZBarSDK.h"
#import <CAPKit/CAPKit.h>
#import <CAPKit/UIApplication+UIApplication_AppDimensions.h>

@implementation ZBarReaderViewController (DisableRotation)

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation{
    return NO;
}

- (NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskPortrait;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation{
    return UIInterfaceOrientationPortrait;
}

- (BOOL)shouldAutorotate{
    return YES;
}

@end

@implementation ZBarService

+(void)load{
    [[ESRegistry getInstance] registerService: @"ZBarService" withName: @"zbar"];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _gbkEncoding = YES;
    }
    return self;
}

-(BOOL)singleton{
    return NO;
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
    if (_reader) {
        [_reader dismissViewControllerAnimated: YES
                                    completion:^{
                                        if ([oncompleted isKindOfClass: [LuaFunction class]]) {
                                            [oncompleted executeWithoutReturnValue];
                                        }
                                    }];

        _callback = nil;
    }
}

- (void) take {
    if (_reader) {
        [_reader takePicture];
    }
}

- (void) addConfig:(NSString *)value {
    if ([value isKindOfClass: [NSString class]]) {
        [configs addObject: value];
    }
}

- (void) removeAllConfig{
    [configs removeAllObjects];
}

-(void)onLoad{
    configs = [NSMutableArray array];
    scanCrop = CGRectMake(0, 0, 1, 1);
}

- (NSArray *) scanImage: (CAPLuaImage *) image{
    if (!_reader) {
        _reader = [ZBarReaderViewController new];
        _reader.supportedOrientationsMask = ZBarOrientationMaskAll;
    }

    ZBarImage *zbImage = [[ZBarImage alloc] initWithCGImage: [image.image CGImage]];
    [_reader.scanner scanImage: zbImage];
    
    NSMutableArray *list = [NSMutableArray array];
    for(ZBarSymbol *symbol in zbImage.symbols){
        NSDictionary *dic = @{@"type": symbol.typeName, @"data": symbol.data};
        [list addObject: dic];
    }
    
    return list;
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
    
    if (!_reader) {
        _reader = [ZBarReaderViewController new];
    }
    
    _reader.readerDelegate = self;
    _reader.supportedOrientationsMask = ZBarOrientationMaskAll;

    if (UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation)) {
        _reader.scanCrop = scanCrop;
    } else {
        _reader.scanCrop = CGRectMake(scanCrop.origin.y, scanCrop.origin.x, scanCrop.size.height, scanCrop.size.width);
    }

    if (_overlay) {
        CGSize size = [UIApplication currentSize];
        
        CGRect rect = [_overlay measureRect: [[_overlay.pageSandbox getAppSandbox].scale getRefSize: size]];
        //    [widget reloadSize: rect.size];
        [[_overlay innerView] removeFromSuperview];
        
        
        if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_6_1){
            _overlay->currentRect = CGRectMake(0, 0, rect.size.width, rect.size.height);
        }else{
            _overlay->currentRect = CGRectMake(0, [UIApplication statusBarHeight], rect.size.width, rect.size.height);
        }
        [_overlay reloadRect];
        
        [_overlay createView];
        [_overlay reLayoutChildren];
        [_overlay onFronted];
        
        [_overlay innerView].hidden = NO;
        
        _reader.cameraOverlayView = [_overlay innerView];
        _reader.showsZBarControls = NO;
    }

    ZBarImageScanner *scanner = _reader.scanner;
    [scanner setSymbology: ZBAR_I25
                   config: ZBAR_CFG_ENABLE
                       to: 0];
    for (NSString *config in configs) {
        [scanner parseConfig: config];
    }
    
    // present and release the controller
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController: _reader
                                                                                 animated: YES
                                                                               completion:^{

                                                                               }];

}

- (void) readerControllerDidFailToRead: (ZBarReaderController*) reader
                             withRetry: (BOOL) retry{
    
}

- (void) imagePickerController: (UIImagePickerController*) reader
 didFinishPickingMediaWithInfo: (NSDictionary*) info
{
    // ADD: get the decode results
    id<NSFastEnumeration> results = [info objectForKey: ZBarReaderControllerResults];
    
    [reader dismissViewControllerAnimated: YES
                               completion:^{
                                   
                               }];

    NSMutableArray *list = [NSMutableArray array];
    [list addObject: self];
    for(ZBarSymbol *symbol in results){
        NSString *gbkstr;
        if (_gbkEncoding) {
            NSStringEncoding enc =CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
            gbkstr = [NSString stringWithCString: zbar_symbol_get_data([symbol zbarSymbol]) encoding: enc];
        }
        NSDictionary *dic = @{@"type": symbol.typeName, @"data": _gbkEncoding ? gbkstr : symbol.data};
        [list addObject: dic];
    }

    LuaFunction *callback = _callback;

    [callback executeWithoutReturnValueWithArrayArguments: list];
    _callback = nil;
}

@end
