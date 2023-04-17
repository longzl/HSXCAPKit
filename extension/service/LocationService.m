//
//  LocationService.m
//  EOSFramework
//
//  Created by Sam Chang on 4/27/13.
//
//

#import "LocationService.h"
#import "LuaLocation.h"
#import "LuaHeading.h"

@implementation LocationService

+(void)load{
    [[ESRegistry getInstance] registerService: @"LocationService" withName: @"location"];
}

- (id)init
{
    self = [super init];
    if (self) {
        locationManager = [[CLLocationManager alloc] init];
        locationManager.delegate = self;
        
        watchers = [[NSMutableArray alloc] init];
        headingwatchers = [[NSMutableArray alloc] init];
    }
    return self;
}

-(BOOL)singleton{
    return YES;
}

-(LuaFunctionWatcher *) addLocationWatcher:(LuaFunction *)func{
    if (![func isKindOfClass: [LuaFunction class]]) {
        return nil;
    }
    
    @synchronized(watchers){
        [watchers addObject: func];
    }
    
    return [[LuaFunctionWatcher alloc] initWithLuaFunction: func];
}

-(LuaFunctionWatcher *) addHeadingWatcher:(LuaFunction *)func{
    if (![func isKindOfClass: [LuaFunction class]]) {
        return nil;
    }
    
    @synchronized(headingwatchers){
        [headingwatchers addObject: func];
    }
    
    return [[LuaFunctionWatcher alloc] initWithLuaFunction: func];
}

- (void) setDesiredAccuracy: (NSNumber *) accuracy {
    if ([accuracy isKindOfClass: [NSNumber class]]) {
        locationManager.desiredAccuracy = [accuracy doubleValue];
    }
}

-(LuaTable *) toLuaTable{
    LuaTable *table = [[LuaTable alloc] init];
    [table.map setValue: [NSNumber numberWithDouble: kCLLocationAccuracyBestForNavigation]
                 forKey: @"BestForNavigation"];
    [table.map setValue: [NSNumber numberWithDouble: kCLLocationAccuracyBest]
                 forKey: @"Best"];
    [table.map setValue: [NSNumber numberWithDouble: kCLLocationAccuracyNearestTenMeters]
                 forKey: @"NearestTenMeters"];
    [table.map setValue: [NSNumber numberWithDouble: kCLLocationAccuracyHundredMeters]
                 forKey: @"HundredMeters"];
    [table.map setValue: [NSNumber numberWithDouble: kCLLocationAccuracyKilometer]
                 forKey: @"Kilometer"];
    [table.map setValue: [NSNumber numberWithDouble: kCLLocationAccuracyThreeKilometers]
                 forKey: @"ThreeKilometers"];
    
    [table.map setValue: [NSNumber numberWithBool: [CLLocationManager locationServicesEnabled]]
                 forKey: @"enabled"];
    [table.map setValue: [NSNumber numberWithBool: [CLLocationManager headingAvailable]]
                 forKey: @"headingAvailable"];
    
    return table;
}

- (void) broadcastLocation: (CLLocation *) newLocation{
    LuaLocation *location = [[LuaLocation alloc] initWithLocation: newLocation];

    @synchronized(watchers){
        NSArray *list = [NSArray arrayWithArray: watchers];
        
        for (LuaFunction *watcher in list) {
            if ([watcher isValid]) {
                [watcher executeWithoutReturnValue: location, nil];
            }else{
                [watchers removeObject: watcher];
            }
        }
    }
}

- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation{
    [self broadcastLocation: newLocation];
}

- (void)locationManager:(CLLocationManager *)manager
	 didUpdateLocations:(NSArray *)locations{
    for (CLLocation *location in locations) {
        [self broadcastLocation: location];
    }
}

-(void)locationManager:(CLLocationManager *)manager
      didUpdateHeading:(CLHeading *)newHeading{
    LuaHeading *heading = [[LuaHeading alloc] initWithHeading: newHeading];
    
    @synchronized(headingwatchers){
        NSArray *list = [NSArray arrayWithArray: headingwatchers];
        
        for (LuaFunction *watcher in list) {
            if ([watcher isValid]) {
                [watcher executeWithoutReturnValue: heading, nil];
            }else{
                [headingwatchers removeObject: watcher];
            }
        }
    }
}

-(BOOL) start{
    if (![CLLocationManager locationServicesEnabled]) {
        return NO;
    }

    if ([locationManager respondsToSelector: @selector(requestWhenInUseAuthorization)]) {
        [locationManager requestWhenInUseAuthorization];
    }

    switch ([CLLocationManager authorizationStatus]) {
        case kCLAuthorizationStatusNotDetermined:
            if ([locationManager respondsToSelector: @selector(requestAlwaysAuthorization)]) {
                [locationManager requestAlwaysAuthorization];
            }
        case kCLAuthorizationStatusAuthorized:
            break;
        default:
            break;
    }


    if ([CLLocationManager headingAvailable]) {
        [locationManager startUpdatingHeading];
    }

    [locationManager startUpdatingLocation];
    return YES;
}

- (BOOL) stop{
    if (![CLLocationManager locationServicesEnabled]) {
        return NO;
    }

    if ([CLLocationManager headingAvailable]) {
        [locationManager stopUpdatingHeading];
    }
    
    [locationManager stopUpdatingLocation];
    return YES;
}

- (LuaLocation *) newLocation: (CLLocationDegrees) latitude : (CLLocationDegrees) longitude{
    CLLocation *newLocation = [[CLLocation alloc] initWithLatitude: latitude longitude: longitude];
    LuaLocation *location = [[LuaLocation alloc] initWithLocation: newLocation];
    
    return location;
}

@end
