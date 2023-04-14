#import <CoreLocation/CoreLocation.h>
#import <CAPKit/CAPKit.h>

@interface BeaconService : AbstractLuaTableCompatible <IService, CLLocationManagerDelegate>{
    CLLocationManager *locationManager;
    NSMutableArray *watchers;
    NSMutableArray *statusWatchers;
}

@end
