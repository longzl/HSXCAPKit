#import "BeaconService.h"
#import <CAPKit/GlobalSandbox.h>
#import <CAPKit/LuaFunctionWatcher.h>
#import <CAPKit/OSUtils.h>

@implementation BeaconService

+(void)load{
    if (NSFoundationVersionNumber > NSFoundationVersionNumber_iOS_6_1 && [CLLocationManager isRangingAvailable]) {
        [[ESRegistry getInstance] registerService: @"BeaconService" withName: @"beacon"];
    }
}

-(BOOL)singleton{
    return YES;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        watchers = [[NSMutableArray alloc] init];
        statusWatchers = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void) addRegion: (NSString *) uuidString{
    [OSUtils runBlockOnMain:^{
        if (!locationManager) {
            locationManager = [[CLLocationManager alloc] init];
            locationManager.delegate = self;
            if ([locationManager respondsToSelector: @selector(requestWhenInUseAuthorization)]) {
                [locationManager requestWhenInUseAuthorization];
            }

            NSUUID *uuid = [[NSUUID alloc] initWithUUIDString: uuidString];
            CLBeaconRegion *region = [[CLBeaconRegion alloc] initWithProximityUUID: uuid identifier: uuidString];

            switch ([CLLocationManager authorizationStatus]) {
                case kCLAuthorizationStatusNotDetermined:
                    if ([locationManager respondsToSelector: @selector(requestAlwaysAuthorization)]) {
                        [locationManager requestAlwaysAuthorization];
                    }
                case kCLAuthorizationStatusAuthorized:
                    [locationManager startRangingBeaconsInRegion: region];
                    break;
                default:
                    break;
            }
        }
    }];
}

-(LuaFunctionWatcher *) addRangeWatcher:(LuaFunction *)func{
    if (![func isKindOfClass: [LuaFunction class]]) {
        return nil;
    }

    @synchronized(watchers){
        [watchers addObject: func];
    }

    return [[LuaFunctionWatcher alloc] initWithLuaFunction: func];
}

-(LuaFunctionWatcher *) addStatusWatcher:(LuaFunction *)func{
    if (![func isKindOfClass: [LuaFunction class]]) {
        return nil;
    }

    @synchronized(statusWatchers){
        [statusWatchers addObject: func];
    }

    return [[LuaFunctionWatcher alloc] initWithLuaFunction: func];
}

- (void)locationManager:(CLLocationManager *)manager didRangeBeacons:(NSArray *)beacons inRegion:(CLBeaconRegion *)region
{
    NSMutableArray *beaconList = [[NSMutableArray alloc] init];
    for (CLBeacon *beacon in beacons) {
        [beaconList addObject: @{@"uuid": beacon.proximityUUID.UUIDString,
                                 @"major": beacon.major,
                                 @"minor": beacon.minor,
                                 @"proximity": @(beacon.proximity),
                                 @"accuracy": @(beacon.accuracy),
                                 @"rssi": @(beacon.rssi)}];
    }

    @synchronized(watchers){
        NSArray *list = [NSArray arrayWithArray: watchers];

        for (LuaFunction *watcher in list) {
            if ([watcher isValid]) {
                [watcher executeWithoutReturnValue: region.proximityUUID.UUIDString, beaconList, nil];
            }else{
                [watchers removeObject: watcher];
            }
        }
    }

}

- (void)locationManager:(CLLocationManager *)manager
rangingBeaconsDidFailForRegion:(CLBeaconRegion *)region
              withError:(NSError *)error{
    @synchronized(statusWatchers){
        NSArray *list = [NSArray arrayWithArray: statusWatchers];

        for (LuaFunction *watcher in list) {
            if ([watcher isValid]) {
                [watcher executeWithoutReturnValue: [NSNumber numberWithBool: NO], nil];
            }else{
                [watchers removeObject: watcher];
            }
        }
    }}


@end
