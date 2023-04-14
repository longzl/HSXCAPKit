//
//  ImageProcessController.h
//  ImageManipulation
//
//  Created by JimFu on 12-3-21.
//  Copyright (c) 2014年 Storm ID Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MaskView.h"

//#define MIN_WIDTH 49
//#define MIN_HEIGHT 69
//#define SMALL_WIDTH 196
//#define SMALL_HEIGHT 276
//#define BIG_WIDTH 690
//#define BIG_HEIGHT 970
#define BIG_WIDTH 900
#define BIG_HEIGHT 1267

#define EDIT_IMAGE_DONE @"EDIT_IMAGE_DONE"

@interface ImageProcessController : UIViewController <UIGestureRecognizerDelegate> {
    UIImageView *backImageView;
    CGFloat allScale;
    UIView *layout;
    UIView *lt;
	UIView *lb;
	UIView *rt;
	UIView *rb;
    UIView *highLightView;
    
    CGFloat _lastScale;
    CGFloat _firstX;
	CGFloat _firstY;
    CGPoint _firstP;
    CGAffineTransform _firstTransform;
    CGAffineTransform previousTransform;
    CGPoint previousCenter;
    
    CGFloat expectWidth;
    CGFloat expectHeight;
    CGFloat quality;
    
    UIImage *orginalImage;
    UIImage *changedImage;
    
    MaskView *maskView;
    
    UIActivityIndicatorView *indicatorView;

    CGFloat MAX_WIDTH;
    CGFloat MAX_HEIGHT;
}

@property (nonatomic, strong) UIImage *clippedImage;
@property (nonatomic, strong) UIView *canvas;

-(id)initWithImage: (UIImage *) input withOption:(NSDictionary *)dic;
CGFloat distanceBetweenPoints(CGPoint firstPoint, CGPoint secondPoint);

@end
