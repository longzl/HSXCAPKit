//
//  LuaHeading.h
//  EOSFramework
//
//  Created by JimFu on 13-5-7.
//
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <CAPKit/CAPKit.h>

@interface LuaHeading : AbstractLuaTableCompatible

@property (nonatomic, strong) CLHeading *heading;

- (id)initWithHeading: (CLHeading *) value;
@end
