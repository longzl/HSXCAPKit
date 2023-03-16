//
//  VBoxWidget.m
//  EOSClient2
//
//  Created by Chang Sam on 10/19/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "CAPVBoxWidget.h"
#import "CAPLabelWidget.h"
#import "CAPVBoxM.h"

@implementation CAPVBoxWidget

+(void)load {
    [WidgetMap bind: @"vbox" withModelClassName: NSStringFromClass([CAPVBoxM class]) withWidgetClassName: NSStringFromClass([CAPVBoxWidget class])];
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
    __block CGFloat lastY = 0;

    dispatch_block_t measure = ^{
        CGFloat totalDefinedHeight = 0;
        CGFloat totalUndefinedHeight = 0;

        NSArray *subitems = self.subitems;

        for (CAPAbstractUIWidget *widget in subitems) {
            if (widget.model.hidden) {
                continue;
            }
            PNum *ph = widget.model.height;
            PNum *marginTop = widget.model.marginTop;
            PNum *marginBottom = widget.model.marginBottom;

            if (marginBottom && marginBottom.usingAuto) {
                widget.model.marginBottom = [PNum zero];
                marginBottom = [PNum zero];
            }
            if (marginTop && marginTop.usingAuto) {
                widget.model.marginTop = [PNum zero];
                marginTop = [PNum zero];
            }

            if (ph) {
                totalDefinedHeight += [ph pixelValue: contentRect.size.height];
            }else { // 100%
                totalUndefinedHeight += 100;
            }

            if (marginTop) {
                totalDefinedHeight += [marginTop pixelValue: contentRect.size.height];
            }

            if (marginBottom) {
                totalDefinedHeight += [marginBottom pixelValue: contentRect.size.height];
            }
        }

        if (totalDefinedHeight > contentRect.size.height) {
            totalRect.size.height = totalDefinedHeight + paddingTop + paddingBottom;
            contentRect.size.height = totalDefinedHeight;
        }

        int percentLeftHeight = contentRect.size.height - totalDefinedHeight;
        if(percentLeftHeight < 0){
            percentLeftHeight = 0;
        }

        CGSize virtualSize;
        if (totalUndefinedHeight > 0) {
            virtualSize = CGSizeMake(contentRect.size.width, percentLeftHeight * 100 / totalUndefinedHeight);
        } else {
            virtualSize = CGSizeMake(contentRect.size.width, 0);
        }

        CGFloat currentY = 0;
        for (int i = 0; i < [subitems count]; i++) {
            CAPAbstractUIWidget *widget = [subitems objectAtIndex: i];
            if (widget.model.hidden) {
                continue;
            }

            CGRect rect;

            rect.origin.x = contentRect.origin.x;
            rect.origin.y = currentY + contentRect.origin.y;
            rect.size.width = contentRect.size.width;

            PNum *ph = widget.model.height;

            CGRect expectedRect;
            if (ph) {
                expectedRect = [widget measureRect: contentRect.size withAbsolute: YES];
            } else {
                expectedRect = [widget measureRect: virtualSize withAbsolute: YES];
            }

            //merge, ignore height
            rect.size.width = expectedRect.size.width;
            rect.size.height = expectedRect.size.height;
            rect.origin.x += expectedRect.origin.x;
            rect.origin.y += expectedRect.origin.y;
            currentY += expectedRect.origin.y + expectedRect.size.height
            + [widget.model.marginBottom pixelValue: contentRect.size.height withDefault: 0];

            if (((CAPViewM *) self.model).overflow == OverflowTypeVisible && [widget isKindOfClass: [CAPViewWidget class]]
                && ph && !ph.percentage && ph.value < expectedRect.size.height) {
                widget.model.height = [PNum pnumWithValue: expectedRect.size.height withPercentage: NO];
                needMeasureAgain = YES;
            }

            widget->currentRect = rect;
            lastY = currentY + contentRect.origin.y + paddingBottom;
        }
    };

    measure();

    if (totalRect.size.height < lastY) {
        totalRect.size.height = lastY;
    } else if (!self.model.height.percentage && self.model.height.value < totalRect.size.height && totalRect.size.height != lastY){
        totalRect.size.height = lastY;
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
    __block CGFloat lastY = 0;

    dispatch_block_t measure = ^{
        CGFloat totalFixedHeight = 0;
        CGFloat totalPencentageHeight = 0;

        NSArray *subitems = self.subitems;
        for (CAPAbstractUIWidget *widget in subitems) {
            if (widget.model.hidden) {
                continue;
            }
            PNum *ph = widget.model.height;
            PNum *marginTop = widget.model.marginTop;
            PNum *marginBottom = widget.model.marginBottom;

            if (marginBottom && marginBottom.usingAuto) {
                widget.model.marginBottom = [PNum zero];
                marginBottom = [PNum zero];
            }
            if (marginTop && marginTop.usingAuto) {
                widget.model.marginTop = [PNum zero];
                marginTop = [PNum zero];
            }

            if (ph) {
                if (ph.percentage) {
                    totalPencentageHeight += ph.value;
                }else{
                    totalFixedHeight += ph.value;
                }
            }else { // 100%
                totalPencentageHeight += 100;
            }

            if (marginTop) {
                if (marginTop.percentage) {
                    totalPencentageHeight += marginTop.value;
                } else {
                    totalFixedHeight += marginTop.value;
                }
            }

            if (marginBottom) {
                if (marginBottom.percentage) {
                    totalPencentageHeight += marginBottom.value;
                } else {
                    totalFixedHeight += marginBottom.value;
                }
            }
        }
        
        if (totalFixedHeight > contentRect.size.height) {
            totalRect.size.height = totalFixedHeight + paddingTop + paddingBottom;
            contentRect.size.height = totalFixedHeight;
        }
        
        int percentLeftHeight = contentRect.size.height - totalFixedHeight;
        if(percentLeftHeight < 0){
            percentLeftHeight = 0;
        }

        CGSize virtualSize;
        if (totalPencentageHeight > 0) {
            virtualSize = CGSizeMake(contentRect.size.width, percentLeftHeight * 100 / totalPencentageHeight);
        } else {
            virtualSize = CGSizeMake(contentRect.size.width, 0);
        }

        CGFloat currentY = 0;
        for (int i = 0; i < [subitems count]; i++) {
            CAPAbstractUIWidget *widget = [subitems objectAtIndex: i];
            if (widget.model.hidden) {
                continue;
            }
            
            CGRect rect;

            rect.origin.x = contentRect.origin.x;
            rect.origin.y = currentY + contentRect.origin.y;
            rect.size.width = contentRect.size.width;

            PNum *ph = widget.model.height;

            CGRect expectedRect = [widget measureRect: virtualSize];

            //merge, ignore height
            rect.size.width = expectedRect.size.width;
            rect.size.height = expectedRect.size.height;
            rect.origin.x += expectedRect.origin.x;
            rect.origin.y += expectedRect.origin.y;
            currentY += expectedRect.origin.y + expectedRect.size.height
            + [widget.model.marginBottom pixelValue: virtualSize.height withDefault: 0];

            if (((CAPViewM *) self.model).overflow == OverflowTypeVisible && [widget isKindOfClass: [CAPViewWidget class]]
                && ph && !ph.percentage && ph.value < expectedRect.size.height) {
                widget.model.height = [PNum pnumWithValue: expectedRect.size.height withPercentage: NO];
                needMeasureAgain = YES;
            }

            widget->currentRect = rect;
            lastY = currentY + contentRect.origin.y + paddingBottom;
        }
    };
    
    measure();
    
    if (totalRect.size.height < lastY) {
        totalRect.size.height = lastY;
    } else if (!self.model.height.percentage && self.model.height.value < totalRect.size.height && totalRect.size.height != lastY){
        totalRect.size.height = lastY;
    }

    if (needMeasureAgain) {
        measure();
    }

    return totalRect;
}

@end
