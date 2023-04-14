//
//  EOSLabel.h
//  EOSFramework
//
//  Created by Sam on 5/16/12.
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CAPLabelWidget;
@class CAPPageSandbox;

typedef enum VerticalAlignment {
    VerticalAlignmentTop,
    VerticalAlignmentMiddle,
    VerticalAlignmentBottom,
} VerticalAlignment;

@interface EOSLabel : UILabel{
}

@property (nonatomic, assign) VerticalAlignment verticalAlign;
@property (nonatomic, weak) CAPPageSandbox *pageSandbox;
@property (nonatomic, weak) CAPLabelWidget *widget;

@end
