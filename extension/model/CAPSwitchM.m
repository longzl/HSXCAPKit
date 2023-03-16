//
//  SwitchM.m
//  EOSFramework
//
//  Created by Sam on 6/20/12.
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import "CAPSwitchM.h"

@implementation CAPSwitchM

- (void)mergeFromDic:(NSDictionary *)dic{
    [super mergeFromDic: dic];
    
    if ([dic valueForKey: @"checked"]) {
        _checked = [[dic valueForKey: @"checked"] boolValue];
    }
}

@end
