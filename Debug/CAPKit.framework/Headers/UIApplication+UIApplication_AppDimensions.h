//
//  UIApplication+UIApplication_AppDimensions.h
//  EOSFramework
//
//  Created by Sam Chang on 10/23/12.
//
//

#import <UIKit/UIKit.h>

@interface UIApplication (UIApplication_AppDimensions)

+(CGSize) currentSize;
+(CGFloat) statusBarHeight;
+(CGSize) sizeInOrientation:(UIInterfaceOrientation)orientation;

@end
