//
//  ButtonM.m
//  EOSClient2
//
//  Created by Song on 10/17/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "CAPButtonM.h"

@implementation CAPButtonM

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.showsTouch = YES;
        self.exclusiveTouch = YES;
    }
    return self;
}

- (void) mergeFromDic: (NSDictionary *) dic{
    [super mergeFromDic: dic];
    
    if ([dic valueForKey: @"align"]) {
        self.align = [dic valueForKey: @"align"];
    }
    if ([dic valueForKey: @"color"]) {
        self.color = [dic valueForKey: @"color"];
    }
    if ([dic valueForKey: @"bold"]) {
        self.bold = [[dic valueForKey: @"bold"] boolValue];
    }
    if ([dic valueForKey: @"fontName"]) {
        self.fontName = [dic valueForKey: @"fontName"];
    }
    if ([dic valueForKey: @"label"]) {
        self.label = [dic valueForKey: @"label"];
    }
    if ([dic valueForKey: @"fontSize"]) {
        self.fontSize = [[dic valueForKey: @"fontSize"] floatValue];
    }
    if ([dic valueForKey: @"underline"]) {
        self.underline = [[dic valueForKey: @"underline"] boolValue];
    }
    if ([dic valueForKey: @"showsTouchWhenHighlighted"]) {
        self.showsTouchWhenHighlighted = [[dic valueForKey: @"showsTouchWhenHighlighted"] boolValue];
    }
    if ([dic valueForKey: @"exclusiveTouch"]) {
        self.exclusiveTouch = [[dic valueForKey: @"exclusiveTouch"] boolValue];
    }
    if ([dic valueForKey: @"showsTouch"]) {
        self.showsTouch = [[dic valueForKey: @"showsTouch"] boolValue];
    }
    if ([dic valueForKey: @"onclick"]) {
        self.onclick = [dic valueForKey: @"onclick"];
    }
    if ([dic valueForKey: @"onmousedown"]) {
        self.onmousedown = [dic valueForKey: @"onmousedown"];
    }
    if ([dic valueForKey: @"onmouseup"]) {
        self.onmouseup = [dic valueForKey: @"onmouseup"];
    }
}

-(id)copyWithZone:(NSZone *)zone{
    CAPButtonM *m = [super copyWithZone: zone];
    m.label = _label;
    m.onclick = _onclick;
    m.onmousedown = _onmousedown;
    m.onmouseup = _onmouseup;
    m.fontName = _fontName;
    m.fontSize = _fontSize;
    m.color = _color;
    m.bold = _bold;
    m.align = _align;
    m.underline = _underline;
    m.showsTouchWhenHighlighted = _showsTouchWhenHighlighted;
    m.showsTouch = _showsTouch;
    m.exclusiveTouch = _exclusiveTouch;
    
    return m;
}
@end
