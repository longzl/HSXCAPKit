//
//  IScrollViewWidget.h
//  EOSFramework
//
//  Created by Sam Chang on 3/21/12.
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import <CAPKit/CAPKit.h>

@protocol IScrollViewWidget <NSObject>

- (BOOL) scrollX: (float) value;
- (BOOL) scrollY: (float) value;

- (void) setContentOffset: (float) x : (float) y;
- (void) setContentOffset: (float) x : (float) y : (NSNumber *) animated;
- (PackedArray *) getContentOffset;

- (void) setContentSize: (float) width : (float) height;
- (PackedArray *) getContentSize;

- (void) closeDragDown;

@end
