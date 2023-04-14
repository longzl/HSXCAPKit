#import <CoreLocation/CoreLocation.h>
#import <CAPKit/CAPKit.h>

@interface BeaconService : AbstractLuaTableCompatible <IService, CLLocationManagerDelegate>

@property (nonatomic) CLLocationManager *locationManager;
@property (nonatomic) NSMutableArray *watchers;
@property (nonatomic) NSMutableArray *statusWatchers;

@end
