//
//  CanvasDisplayView.m
//  EOSFramework
//
//  Created by Sam on 5/9/12.
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import "CanvasDisplayView.h"

@implementation CanvasDisplayView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.clearsContextBeforeDrawing = NO;
        
        _lock = [[NSRecursiveLock alloc] init];
        _schedulingNeedsDisplay = NO;
    }
    return self;
}

- (void) addNeedsDisplayRect: (CGRect) rect{
    [self.lock lock];
    
    if (!self.schedulingNeedsDisplay) {
        self.schedulingNeedsDisplay = YES;
        
        double delayInSeconds = 0.05;
        
        __weak typeof(self) weakSelf = self;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [weakSelf.lock lock];
            [weakSelf setNeedsDisplay];
            weakSelf.schedulingNeedsDisplay = NO;
            [weakSelf.lock unlock];
        });
    }
    [self.lock unlock];
}

- (void)drawRect:(CGRect)rect
{
    //NSLog(@"drawRect:%@", NSStringFromCGRect(rect));
	CGRect bos = self.bounds;
    rect.origin.y = bos.size.height - rect.origin.y - rect.size.height;
	
    CGRect flipped = CGRectIntersection( bos, rect );
    
    @autoreleasepool {
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSaveGState(context);
        
        [bitmapLock lock];
        CGImageRef imgRef = CGBitmapContextCreateImage(bitmapContext);
        CGImageRef crop = CGImageCreateWithImageInRect(imgRef, flipped);
        
        CGContextDrawImage(context, rect, crop);
        CGImageRelease(crop);
        CGImageRelease(imgRef);
        [bitmapLock unlock];
        
        CGContextRestoreGState(context);
    }
}

@end
