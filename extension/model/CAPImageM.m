//
//  ImageM.m
//  EOSClient2
//
//  Created by Song on 10/17/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "CAPImageM.h"

@implementation CAPImageM

-(void)mergeFromDic:(NSDictionary *)dic{
    [super mergeFromDic: dic];
    
    if ([dic valueForKey: @"src"]) {
        self.src = [dic valueForKey: @"src"];
    }
    if ([dic valueForKey: @"scale"]) {
        self.scale = [dic valueForKey: @"scale"];
    }
    if ([dic valueForKey: @"placeholder"]) {
        self.placeholder = [dic valueForKey: @"placeholder"];
    }
}

-(void)fillSelfDic:(NSMutableDictionary *)dic{
    [super fillSelfDic: dic];
    
    if (_src) {
        [dic setValue: _src forKey: @"src"];
    }
    if (_scale) {
        [dic setValue: _scale forKey: @"scale"];
    }
    if (_placeholder) {
        [dic setValue: _placeholder forKey: @"placeholder"];
    }
}

-(id)copyWithZone:(NSZone *)zone{
    CAPImageM *m = [super copyWithZone: zone];
    m.src = _src;
    m.scale = _scale;
    m.placeholder = _placeholder;
    return m;
}

@end
