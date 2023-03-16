//
//  ScrollViewM.m
//  EOSClient2
//
//  Created by Chang Sam on 11/2/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "CAPScrollViewM.h"
#import <CAPKit/CAPKit.h>

@implementation CAPScrollViewM

-(void)mergeFromDic:(NSDictionary *)dic{
    [super mergeFromDic: dic];
    
    if ([dic valueForKey: @"pagingEnabled"]) {
        _pagingEnabled = [[dic valueForKey: @"pagingEnabled"] boolValue];
    }
    if ([dic valueForKey: @"decelerationEnabled"]) {
        _decelerationEnabled = [[dic valueForKey: @"decelerationEnabled"] boolValue];
    }
    if ([dic valueForKey: @"dragDownLayout"]) {
        self.dragDownLayout = [ModelBuilder buildModel: [dic valueForKey: @"dragDownLayout"]];
    }
    if ([dic valueForKey: @"dragDownMinMovement"]) {
        self.dragDownMinMovement = [[dic valueForKey: @"dragDownMinMovement"] floatValue];
    }
    if ([dic valueForKey: @"onDragDownStateChanged"]) {
        self.onDragDownStateChanged = [dic valueForKey: @"onDragDownStateChanged"];
    }
    if ([dic valueForKey: @"onDragDownAction"]) {
        self.onDragDownAction = [dic valueForKey: @"onDragDownAction"];
    }
}

-(id)init{
    self = [super init];
    
    if (self) {
        self.decelerationEnabled = YES;
    }
    
    return self;
}

-(id)copyWithZone:(NSZone *)zone{
    CAPScrollViewM *m = [super copyWithZone: zone];
    
    m.pagingEnabled = _pagingEnabled;
    m.decelerationEnabled = _decelerationEnabled;

    m.onDragDownAction = _onDragDownAction;
    m.onDragDownStateChanged = _onDragDownStateChanged;
    m.dragDownLayout = [_dragDownLayout copy];
    m.dragDownMinMovement = _dragDownMinMovement;

    return m;
}

-(void)fillSelfDic:(NSMutableDictionary *)dic{
    [super fillSelfDic: dic];
    
    if (_pagingEnabled) {
        [dic setValue: [NSNumber numberWithBool: _pagingEnabled] forKey: @"pagingEnabled"];
    }
    
    if (_decelerationEnabled) {
        [dic setValue: [NSNumber numberWithBool: _decelerationEnabled] forKey: @"decelerationEnabled"];
    }
}

@end
