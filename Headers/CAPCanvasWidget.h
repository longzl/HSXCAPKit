//
//  CanvasWidget.h
//  EOSFramework
//
//  Created by Sam on 5/9/12.
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import <CAPKit/CAPKit.h>
#import "ICanvasWidget.h"

@class CanvasDisplayView;

@interface CAPCanvasWidget : CAPAbstractUIWidget <ICanvasWidget>{
    CanvasDisplayView *view;
    
    CGContextRef bitmapContext;
    void *bitmapBuff;
    
    NSRecursiveLock *bitmapLock;
}


@end
