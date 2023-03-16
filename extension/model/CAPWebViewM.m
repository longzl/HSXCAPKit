//
//  WebViewM.m
//  EOSClient2
//
//  Created by Song on 10/17/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "CAPWebViewM.h"

@implementation CAPWebViewM

-(void)mergeFromDic:(NSDictionary *)dic{
    [super mergeFromDic: dic];
    
    if ([dic valueForKey: @"zoomable"]) {
        self.zoomable = [[dic valueForKey: @"zoomable"] boolValue];
    }
    
    if ([dic valueForKey: @"busyhidden"]) {
        self.busyhidden = [[dic valueForKey: @"busyhidden"] boolValue];
    }
    
    if ([dic valueForKey: @"src"]) {
        self.src = [dic valueForKey: @"src"];
    }
    
    if ([dic valueForKey: @"opaque"]) {
        self.opaque = [[dic valueForKey: @"opaque"] boolValue];
    }

    if ([dic valueForKey: @"jit"]) {
        self.jit = [[dic valueForKey: @"jit"] boolValue];
    }

    if ([dic valueForKey: @"didStartLoad"]) {
        self.didStartLoad = [dic valueForKey: @"didStartLoad"];
    }
    
    if ([dic valueForKey: @"didStopLoad"]) {
        self.didStopLoad = [dic valueForKey: @"didStopLoad"];
    }
}

- (id)init
{
    self = [super init];
    if (self) {
        self.opaque = YES;
    }
    return self;
}

-(id)copyWithZone:(NSZone *)zone{
    CAPWebViewM *m = [super copyWithZone: zone];
    m.src = _src;
    m.zoomable = _zoomable;
    m.opaque = _opaque;
    m.jit = _jit;
    m.busyhidden = _busyhidden;
    
    return m;
}
@end
