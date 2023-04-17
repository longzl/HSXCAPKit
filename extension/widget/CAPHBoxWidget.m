//
//  HBoxWidget.m
//  EOSClient2
//
//  Created by Chang Sam on 10/19/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "CAPHBoxWidget.h"
#import "CAPHBoxM.h"

@implementation CAPHBoxWidget

+(void)load{
    [WidgetMap bind: @"hbox" withModelClassName: NSStringFromClass([CAPHBoxM class]) withWidgetClassName: NSStringFromClass([CAPHBoxWidget class])];
}

-(CGRect)measureRect:(CGSize)parentContentSize{
    if (self.model.layout == LayoutTypeAbsolute) {
        return [self measureRectAbsoluteChildren: parentContentSize];
    } else {
        return [self measureRectDefault: parentContentSize];
    }
}

-(CGRect)measureRectAbsoluteChildren:(CGSize)parentContentSize{
    __block CGRect totalRect = [super measureSelfRect: parentContentSize];

    float paddingLeft = [self.model.paddingLeft pixelValue: parentContentSize.width withDefault: 0];
    float paddingRight = [self.model.paddingRight pixelValue: parentContentSize.width withDefault: 0];
    float paddingTop = [self.model.paddingTop pixelValue: parentContentSize.height withDefault: 0];
    float paddingBottom = [self.model.paddingBottom pixelValue: parentContentSize.height withDefault: 0];

    contentRect = CGRectMake(paddingLeft, paddingTop,
                             totalRect.size.width - paddingLeft - paddingRight,
                             totalRect.size.height - paddingTop - paddingBottom);

    __block BOOL needMeasureAgain = NO;
    __block CGFloat lastX = 0;

    dispatch_block_t measure = ^{
        CGFloat totalDefinedWidth = 0;
        CGFloat totalUndefinedWidth = 0;

        NSArray *subitems = self.subitems;

        for (CAPAbstractUIWidget *widget in subitems) {
            if (widget.model.hidden) {
                continue;
            }
            PNum *ph = widget.model.width;
            PNum *marginLeft = widget.model.marginLeft;
            PNum *marginRight = widget.model.marginRight;

            if (marginLeft && marginLeft.usingAuto) {
                widget.model.marginLeft = [PNum zero];
                marginLeft = [PNum zero];
            }
            if (marginRight && marginRight.usingAuto) {
                widget.model.marginRight = [PNum zero];
                marginRight = [PNum zero];
            }

            if (ph) {
                totalDefinedWidth += [ph pixelValue: contentRect.size.width];
            }else { // 100%
                totalUndefinedWidth += 100;
            }

            if (marginLeft) {
                totalDefinedWidth += [marginLeft pixelValue: contentRect.size.width];
            }

            if (marginRight) {
                totalDefinedWidth += [marginRight pixelValue: contentRect.size.width];
            }
        }

        if (totalDefinedWidth > contentRect.size.width) {
            totalRect.size.width = totalDefinedWidth + paddingLeft + paddingRight;
            contentRect.size.width = totalDefinedWidth;
        }

        int percentLeftWidth = contentRect.size.width - totalDefinedWidth;
        if(percentLeftWidth < 0){
            percentLeftWidth = 0;
        }

        CGSize virtualSize;
        if (totalUndefinedWidth > 0) {
            virtualSize = CGSizeMake(percentLeftWidth * 100 / totalUndefinedWidth, contentRect.size.height);
        } else {
            virtualSize = CGSizeMake(0, contentRect.size.height);
        }

        CGFloat currentX = 0;
        for (int i = 0; i < [subitems count]; i++) {
            CAPAbstractUIWidget *widget = [subitems objectAtIndex: i];
            if (widget.model.hidden) {
                continue;
            }

            CGRect rect;

            rect.origin.y = contentRect.origin.y;
            rect.origin.x = currentX + contentRect.origin.x;
            rect.size.height = contentRect.size.height;

            PNum *ph = widget.model.width;

            CGRect expectedRect;
            if (ph) {
                expectedRect = [widget measureRect: contentRect.size withAbsolute: YES];
            } else {
                expectedRect = [widget measureRect: virtualSize withAbsolute: YES];
            }

            //merge, ignore width
            rect.size.height = expectedRect.size.height;
            rect.size.width = expectedRect.size.width;
            rect.origin.y += expectedRect.origin.y;
            rect.origin.x += expectedRect.origin.x;
            currentX += expectedRect.origin.x + expectedRect.size.width
            + [widget.model.marginRight pixelValue: contentRect.size.width withDefault: 0];

            if (((CAPViewM *) self.model).overflow == OverflowTypeVisible && [widget isKindOfClass: [CAPViewWidget class]]
                && ph && !ph.percentage && ph.value < expectedRect.size.width) {
                widget.model.width = [PNum pnumWithValue: expectedRect.size.width withPercentage: NO];
                needMeasureAgain = YES;
            }

            widget->currentRect = rect;

            lastX = currentX + contentRect.origin.x + paddingRight;
        }
    };

    measure();

    if (totalRect.size.width < lastX) {
        totalRect.size.width = lastX;
    } else if (!self.model.width.percentage && self.model.width.value < totalRect.size.width && totalRect.size.width != lastX){
        totalRect.size.width = lastX;
    }
    
    if (needMeasureAgain) {
        measure();
    }
    
    
    return totalRect;
}

-(CGRect)measureRectDefault:(CGSize)parentContentSize{
    __block CGRect totalRect = [super measureSelfRect: parentContentSize];
    
    float paddingLeft = [self.model.paddingLeft pixelValue: parentContentSize.width withDefault: 0];
    float paddingRight = [self.model.paddingRight pixelValue: parentContentSize.width withDefault: 0];
    float paddingTop = [self.model.paddingTop pixelValue: parentContentSize.height withDefault: 0];
    float paddingBottom = [self.model.paddingBottom pixelValue: parentContentSize.height withDefault: 0];
    
    contentRect = CGRectMake(paddingLeft, paddingTop,
                             totalRect.size.width - paddingLeft - paddingRight,
                             totalRect.size.height - paddingTop - paddingBottom);
    
    __block BOOL needMeasureAgain = NO;
    __block CGFloat lastX = 0;

    dispatch_block_t measure = ^{
        CGFloat totalFixedWidth = 0;
        CGFloat totalPencentageWidth = 0;

        NSArray *subitems = self.subitems;

        for (CAPAbstractUIWidget *widget in subitems) {
            if (widget.model.hidden) {
                continue;
            }
            PNum *ph = widget.model.width;
            PNum *marginLeft = widget.model.marginLeft;
            PNum *marginRight = widget.model.marginRight;

            if (marginLeft && marginLeft.usingAuto) {
                widget.model.marginLeft = [PNum zero];
                marginLeft = [PNum zero];
            }
            if (marginRight && marginRight.usingAuto) {
                widget.model.marginRight = [PNum zero];
                marginRight = [PNum zero];
            }

            if (ph) {
                if (ph.percentage) {
                    totalPencentageWidth += ph.value;
                }else{
                    totalFixedWidth += ph.value;
                }
            }else { // 100%
                totalPencentageWidth += 100;
            }

            if (marginLeft) {
                if (marginLeft.percentage) {
                    totalPencentageWidth += marginLeft.value;
                } else {
                    totalFixedWidth += marginLeft.value;
                }
            }

            if (marginRight) {
                if (marginRight.percentage) {
                    totalPencentageWidth += marginRight.value;
                } else {
                    totalFixedWidth += marginRight.value;
                }
            }
        }
        
        if (totalFixedWidth > contentRect.size.width) {
            totalRect.size.width = totalFixedWidth + paddingLeft + paddingRight;
            contentRect.size.width = totalFixedWidth;
        }
        
        int percentLeftWidth = contentRect.size.width - totalFixedWidth;
        if(percentLeftWidth < 0){
            percentLeftWidth = 0;
        }

        CGSize virtualSize;
        if (totalPencentageWidth > 0) {
            virtualSize = CGSizeMake(percentLeftWidth * 100 / totalPencentageWidth, contentRect.size.height);
        } else {
            virtualSize = CGSizeMake(0, contentRect.size.height);
        }
        
        CGFloat currentX = 0;
        for (int i = 0; i < [subitems count]; i++) {
            CAPAbstractUIWidget *widget = [subitems objectAtIndex: i];
            if (widget.model.hidden) {
                continue;
            }
            
            CGRect rect;

            rect.origin.y = contentRect.origin.y;
            rect.origin.x = currentX + contentRect.origin.x;
            rect.size.height = contentRect.size.height;

            PNum *ph = widget.model.width;

            CGRect expectedRect = [widget measureRect: virtualSize];

            //merge, ignore width
            rect.size.height = expectedRect.size.height;
            rect.size.width = expectedRect.size.width;
            rect.origin.y += expectedRect.origin.y;
            rect.origin.x += expectedRect.origin.x;
            currentX += expectedRect.origin.x + expectedRect.size.width
            + [widget.model.marginRight pixelValue: virtualSize.width withDefault: 0];

            if (((CAPViewM *) self.model).overflow == OverflowTypeVisible && [widget isKindOfClass: [CAPViewWidget class]]
                && ph && !ph.percentage && ph.value < expectedRect.size.width) {
                widget.model.width = [PNum pnumWithValue: expectedRect.size.width withPercentage: NO];
                needMeasureAgain = YES;
            }

            widget->currentRect = rect;

            lastX = currentX + contentRect.origin.x + paddingRight;
        }
    };
    
    measure();
    
    if (totalRect.size.width < lastX) {
        totalRect.size.width = lastX;
    } else if (!self.model.width.percentage && self.model.width.value < totalRect.size.width && totalRect.size.width != lastX){
        totalRect.size.width = lastX;
    }
    
    if (needMeasureAgain) {
        measure();
    }
    
    
    return totalRect;
}

@end
