//
//  LabelWidget.h
//  EOSClient2
//
//  Created by Chang Sam on 10/19/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <CAPKit/CAPKit.h>
#import "ILabelWidget.h"
#import "EOSLabel.h"
#import "CAPLabelM.h"
#import "DTAttributedLabel.h"

@interface CAPLabelWidget : CAPAbstractUIWidget <ILabelWidget>{
    EOSLabel *labelView;
    DTAttributedLabel *attributedLabelView;
    UIView *view;
}

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-property-synthesis"
@property (nonatomic, readonly) CAPLabelM *model;
@property (nonatomic, readonly) CAPLabelM *stableModel;
#pragma clang diagnostic pop

@end
