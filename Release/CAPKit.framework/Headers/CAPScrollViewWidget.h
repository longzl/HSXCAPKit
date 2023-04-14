//
//  ScrollViewWidget.h
//  EOSClient2
//
//  Created by Chang Sam on 11/2/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CAPKit/CAPKit.h>
#import "IScrollViewWidget.h"
#import "CAPScrollViewM.h"
#import "EGORefreshScrollView.h"

@interface CAPScrollViewWidget : CAPViewWidget <IScrollViewWidget, UIScrollViewDelegate, EGORefreshScrollViewDelegate>{
    CGPoint oldContentOffset;
    CGSize currentContentSize;
    CGPoint currentContentOffset;
    
    BOOL dragDowning;
}

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-property-synthesis"
@property (nonatomic, readonly) CAPScrollViewM *model;
@property (nonatomic, readonly) CAPScrollViewM *stableModel;
#pragma clang diagnostic pop

@property (nonatomic, weak) CAPAbstractUIWidget *editingFocusView;

@property (nonatomic, strong) EGORefreshScrollView *refreshScrollView;

@end
