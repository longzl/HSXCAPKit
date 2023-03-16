//
//  ViewWidget.h
//  EOSClient2
//
//  Created by Song on 10/17/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CAPKit/CAPView.h>

/**The View Widget*/
@interface CAPViewWidget : CAPAbstractUIWidget<IViewWidget>{
    NSMutableArray *internalSubitems;
    CGRect contentRect;
    UIView *view;
    
    BOOL initedSubview;
}

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-property-synthesis"
@property (nonatomic, readonly) CAPViewM *model;
@property (nonatomic, readonly) CAPViewM *stableModel;
#pragma clang diagnostic pop

@property (nonatomic, readonly, getter=getSubitems) NSArray *subitems;

@property (nonatomic, assign) BOOL destroyOnRemoved;

- (void) addWidget: (CAPAbstractUIWidget *) widget;
- (void) addWidget: (CAPAbstractUIWidget *) widget At: (int) idx;

-(id)initWithModel:(UIWidgetM *)m withView: (UIView *) v withPageSandbox: (CAPPageSandbox *) sandbox;

- (void) reLayoutChildren;
- (void) removeAllChildren;

#ifdef DEBUG_EOS
- (NSUInteger) childrenCount;
- (NSUInteger) affectCount;
#endif

@end
