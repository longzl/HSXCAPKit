//
//  EOSLabel.m
//  EOSFramework
//
//  Created by Sam on 5/16/12.
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import "EOSLabel.h"
#import "CAPLabelM.h"
#import "CAPLabelWidget.h"

@implementation EOSLabel

@synthesize verticalAlign;

- (CGRect)textRectForBounds:(CGRect)bounds limitedToNumberOfLines:(NSInteger)numberOfLines {
    CGRect contentRect = bounds;
    
    ScreenScale *scale = [_pageSandbox getAppSandbox].scale;
    
    if (self.widget.model.paddingLeft) {
        float paddingLeft = [scale getActualLength: [self.widget.model.paddingLeft pixelValue: contentRect.size.width withDefault: 0]];
        if (!isnan(paddingLeft)) {
            contentRect.origin.x += paddingLeft;
            contentRect.size.width -= paddingLeft;
        }
    }
    if (self.widget.model.paddingRight) {
        float paddingRight = [scale getActualLength: [self.widget.model.paddingRight pixelValue: contentRect.size.width withDefault: 0]];
        if (!isnan(paddingRight)) {
            contentRect.size.width -= paddingRight;
        }
    }
    if (self.widget.model.paddingTop) {
        float paddingTop = [scale getActualLength: [self.widget.model.paddingTop pixelValue: contentRect.size.height withDefault: 0]];
        if (!isnan(paddingTop)) {
            contentRect.origin.y += paddingTop;
            contentRect.size.height -= paddingTop;
        }
    }
    if (self.widget.model.paddingBottom) {
        float paddingBottom = [scale getActualLength: [self.widget.model.paddingBottom pixelValue: contentRect.size.height withDefault: 0]];
        if (!isnan(paddingBottom)) {
            contentRect.size.height -= paddingBottom;
        }
    }
    
    CGRect textRect = [super textRectForBounds: contentRect limitedToNumberOfLines:numberOfLines];
    switch (verticalAlign) {
        case VerticalAlignmentTop:
            textRect.origin.y = contentRect.origin.y;
            break;
        case VerticalAlignmentBottom:
            textRect.origin.y = contentRect.origin.y + contentRect.size.height - textRect.size.height;
            break;
        case VerticalAlignmentMiddle:
            // Fall through.
        default:
            textRect.origin.y = contentRect.origin.y + (contentRect.size.height - textRect.size.height) / 2.0;
    }
    
    textRect.size.width = ceilf(textRect.size.width);
    textRect.size.height = ceilf(textRect.size.height);
    
    return textRect;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        verticalAlign = VerticalAlignmentMiddle;
    }
    return self;
}

-(void)drawTextInRect:(CGRect)rect{
    CGRect actualRect = [self textRectForBounds: rect limitedToNumberOfLines: self.numberOfLines];
    [super drawTextInRect: actualRect];    
}

//-(void)dealloc{
//    NSLog(@"dealloc: %s, %d", __FUNCTION__, __LINE__);
//}

@end
