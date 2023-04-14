//
//  DeviceM.h
//  EOSClient2
//
//  Created by Song on 10/17/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <CAPKit/CAPKit.h>

@interface CAPDeviceM : NSObject

@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *name;

+ (CAPDeviceM *) deviceWithType: (NSString *) t withName: (NSString *) n;

@end
