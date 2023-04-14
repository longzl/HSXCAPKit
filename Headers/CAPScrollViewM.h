//
//  ScrollViewM.h
//  EOSClient2
//
//  Created by Chang Sam on 11/2/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CAPKit/CAPKit.h>

@interface CAPScrollViewM : CAPViewM

@property (nonatomic, assign) BOOL pagingEnabled;
@property (nonatomic, assign) BOOL decelerationEnabled;

@property (nonatomic, strong) UIWidgetM *dragDownLayout;
@property (nonatomic, assign) CGFloat dragDownMinMovement;

@property (nonatomic, strong) LuaFunction *onDragDownStateChanged;
@property (nonatomic, strong) LuaFunction *onDragDownAction;

@end
