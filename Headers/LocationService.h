//
//  LocationService.h
//  EOSFramework
//
//  Created by Sam Chang on 4/27/13.
//
//

#import <CAPKit/CAPKit.h>
#import "ILocationService.h"
#import <CoreLocation/CoreLocation.h>

@interface LocationService : AbstractLuaTableCompatible <IService, ILocationService, CLLocationManagerDelegate>{
    NSMutableArray *watchers;
    NSMutableArray *headingwatchers;
    
    CLLocationManager *locationManager;
}

@end
