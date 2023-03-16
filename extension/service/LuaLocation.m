//
//  LuaLocation.m
//  EOSFramework
//
//  Created by Sam Chang on 4/27/13.
//
//

#import "LuaLocation.h"

@implementation LuaLocation

- (id)initWithLocation: (CLLocation *) value
{
    self = [super init];
    if (self) {
        _location = value;
    }
    return self;
}

- (NSTimeInterval) getTimestamp{
    return [_location.timestamp timeIntervalSince1970];
}

- (PackedArray *) getCoordinate{
    CLLocationCoordinate2D coordinate = _location.coordinate;
    return [[PackedArray alloc] initWithArray: @[
            [NSNumber numberWithDouble: coordinate.latitude],
            [NSNumber numberWithDouble: coordinate.longitude]
            ]];
}

- (CLLocationDistance) getAltitude {
    return _location.altitude;
}

- (CLLocationDirection) getCourse {
    return _location.course;
}

- (CLLocationSpeed) getSpeed {
    return _location.speed;
}

- (CLLocationDistance) distanceFromLocation: (LuaLocation *) fromLocation{
    return [_location distanceFromLocation: fromLocation.location];
}

@end
