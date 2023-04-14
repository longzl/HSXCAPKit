//
//  ListM.h
//  EOSClient2
//
//  Created by Chang Sam on 11/9/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <CAPKit/CAPKit.h>

@interface CAPListM : UIWidgetM

@property (nonatomic, strong) NSString *groupBy;
@property (nonatomic, strong) UIWidgetM *header;
@property (nonatomic, strong) UIWidgetM *body;
@property (nonatomic, strong) UIWidgetM *footer;
@property (nonatomic, strong) UIWidgetM *sectionHeader;
@property (nonatomic, strong) UIWidgetM *sectionFooter;
@property (nonatomic, assign) BOOL indexable;

@property (nonatomic, strong) LuaFunction *onselected;

@property (nonatomic, strong) NSObject *__section_header_height;
@property (nonatomic, strong) NSObject *__section_header_data;
@property (nonatomic, strong) NSObject *__section_header_layout;

@property (nonatomic, strong) NSObject *__section_footer_height;
@property (nonatomic, strong) NSObject *__section_footer_data;
@property (nonatomic, strong) NSObject *__section_footer_layout;

@property (nonatomic, strong) NSObject *__row_height;

@property (nonatomic, strong) NSObject *__row_data;
@property (nonatomic, strong) NSObject *__row_layout;
@property (nonatomic, strong) NSObject *__row_count;

@property (nonatomic, strong) NSObject *__row_moveable;

@property (nonatomic, strong) NSObject *__row_onmove;

@property (nonatomic, strong) NSObject *__row_action;

@property (nonatomic, strong) NSObject *__index_titles;

@property (nonatomic, strong) NSObject *__title_index;

@property (nonatomic, strong) NSObject *__section_count;

@property (nonatomic, strong) UIWidgetM *dragDownLayout;
@property (nonatomic, assign) CGFloat dragDownMinMovement;

@property (nonatomic, strong) LuaFunction *onDragDownStateChanged;
@property (nonatomic, strong) LuaFunction *onDragDownAction;

@end
