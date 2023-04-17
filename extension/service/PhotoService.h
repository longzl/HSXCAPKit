#import <Foundation/Foundation.h>
#import <CAPKit/CAPKit.h>

#import <AssetsLibrary/AssetsLibrary.h>

@interface PhotoService : AbstractLuaTableCompatible <IService, LuaTableCompatible>

- (void) load: (LuaFunction *) func;

@end
