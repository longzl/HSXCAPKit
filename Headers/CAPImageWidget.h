//
//  ImageWidget.h
//  EOSClient2
//
//  Created by Song on 10/17/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <CAPKit/CAPKit.h>
#import "IImageWidget.h"
#import "CAPImageM.h"
#import <YLGIFImage/YLGIFImage.h>
#import <YLGIFImage/YLImageView.h>

/**The Image Widget*/
@interface CAPImageWidget : CAPAbstractUIWidget <IImageWidget>{
    YLImageView *imageView;
    UIView *view;
}

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-property-synthesis"
@property (nonatomic, readonly) CAPImageM *model;
@property (nonatomic, readonly) CAPImageM *stableModel;
#pragma clang diagnostic pop

- (void) setImage: (UIImage *) img;
- (UIImage *) getImage;
@end
