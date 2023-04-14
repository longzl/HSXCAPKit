#import <Foundation/Foundation.h>
#import <CoreMotion/CoreMotion.h>
#import <CAPKit/CAPKit.h>

@interface MotionService : AbstractLuaTableCompatible <IService> {
    CMMotionManager *motionManager;
    CMAttitude *referenceAttitude;

    NSMutableArray *watchers;
}

@end
