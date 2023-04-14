//
//  EOSTimer.h
//  EOSFramework
//
//  Created by Sam on 6/7/12.
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import <CAPKit/CAPKit.h>
#import "IEOSTimer.h"
#import "LuaTableCompatible.h"

@class LuaFunction;

@interface EOSTimer : NSObject <IEOSTimer, LuaTableCompatible>

@property (nonatomic) NSTimeInterval sec;
@property (nonatomic) NSString *appId;
@property (nonatomic) LuaFunction *func;
@property (nonatomic) unsigned long long repeat;
@property (atomic) BOOL stop;

- (id)initWithLuaFunction: (LuaFunction *) func withSeconds: (NSTimeInterval) sec withRepeat: (unsigned long long) prepeat;

@end
