//
//  LuaHeading.m
//  EOSFramework
//
//  Created by JimFu on 13-5-7.
//
//

#import "LuaHeading.h"

@implementation LuaHeading

- (id)initWithHeading: (CLHeading *) value
{
    self = [super init];
    if (self) {
        _heading = value;
    }
    return self;
}

- (CLLocationDirection) getMagneticHeading{
    return _heading.magneticHeading;
}

- (CLLocationDirection) getTrueHeading{
    return _heading.trueHeading;
}

- (CLLocationDirection) getHeadingAccuracy{
    return _heading.headingAccuracy;
}

- (CLHeadingComponentValue) getX{
    return _heading.x;
}

- (CLHeadingComponentValue) getY{
    return _heading.y;
}

- (CLHeadingComponentValue) getZ{
    return _heading.z;
}

- (NSTimeInterval) getTimestamp {
    return [_heading.timestamp timeIntervalSince1970];
}

@end
