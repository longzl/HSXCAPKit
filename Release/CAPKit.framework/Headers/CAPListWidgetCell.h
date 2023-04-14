//
//  ListWidgetCell.h
//  EOSFramework
//
//  Created by Chang Sam on 11/17/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CAPKit/CAPKit.h>
#import "BMXSwipableCell.h"

@class CAPListWidget;
@interface CAPListWidgetCell : BMXSwipableCell

@property (nonatomic, strong) CAPAbstractUIWidget *contentWidget;
@property (nonatomic, strong) CAPAbstractUIWidget *actionWidget;
@property (nonatomic, strong) NSMutableDictionary *dp;
@property (nonatomic, weak) CAPListWidget *listWidget;

@property (nonatomic, strong) NSIndexPath *indexPath;


@end
