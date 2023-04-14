//
//  CanvasDisplayView.h
//  EOSFramework
//
//  Created by Sam on 5/9/12.
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CanvasDisplayView : UIView{    
    @public
    CGContextRef bitmapContext;
    NSRecursiveLock *bitmapLock;
}

@property (nonatomic, strong) NSRecursiveLock *lock;
@property (nonatomic, assign) BOOL schedulingNeedsDisplay;

- (void) addNeedsDisplayRect: (CGRect) rect;
@end
