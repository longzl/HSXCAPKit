//
//  ImagePreviewController.h
//  EOSFramework
//
//  Created by JimFu on 12-3-15.
//  Copyright (c) 2014年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImageProcessController.h"
#define PREVIEW_DONE @"PREVIEW_DONE"


@interface ImagePreviewController : UIViewController <UIGestureRecognizerDelegate> {
    UIImage *aImage;
    UIImageView *imageView;
    CGFloat _firstX;
	CGFloat _firstY;
    CGFloat _lastScale;
    CGFloat allScale;
    CGFloat orginalScale;
}

@property (nonatomic, strong) UIImage *aImage;

@end
