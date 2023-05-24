//
//  MaskView.h
//  ImageManipulation
//
//  Created by JimFu on 12-3-23.
//  Copyright (c) 2014年 Storm ID Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface MaskView : UIView {
    CGRect fRect;
    CGRect hRect;
    CGFloat alp;
    
    CAShapeLayer *_marque;
}

- (id)initWithFrame:(CGRect)frame withFullRect:(CGRect)fullRect withHoleRect:(CGRect)holeRect withAlpha:(CGFloat)alpha;
- (void)relayoutMaskView:(CGRect)frame withFullRect:(CGRect)fullRect withHoleRect:(CGRect)holeRect withAlpha:(CGFloat)alpha;

@end
