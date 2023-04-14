//
//  ILocationService.h
//  EOSFramework
//
//  Created by Sam Chang on 4/27/13.
//
//

#import <CAPKit/CAPKit.h>
#import "LuaLocation.h"

@protocol ILocationService <NSObject>

- (LuaFunctionWatcher *) addLocationWatcher: (LuaFunction *) func;
- (LuaFunctionWatcher *) addHeadingWatcher: (LuaFunction *) func;

- (BOOL) start;

- (BOOL) stop;

- (LuaLocation *) newLocation: (CLLocationDegrees) latitude : (CLLocationDegrees) longitude;

@end
