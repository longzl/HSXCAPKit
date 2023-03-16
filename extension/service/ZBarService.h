#import <Foundation/Foundation.h>
#import <CAPKit/CAPKit.h>
#import "ZBarSDK.h"

@interface ZBarService : AbstractLuaTableCompatible <IService, ZBarReaderDelegate> {
    lua_State *L;
    NSMutableArray *configs;
    CGRect scanCrop;
}

@property (nonatomic, strong) CAPViewWidget *overlay;
@property (nonatomic, strong) LuaFunction *callback;
@property (nonatomic, strong) ZBarReaderViewController *reader;

@property (nonatomic, readwrite) BOOL gbkEncoding;

- (void) scan: (LuaFunction *) callback;

@end
