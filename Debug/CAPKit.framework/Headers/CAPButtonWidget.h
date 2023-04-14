//
//  ButtonWidget.h
//  EOSClient2
//
//  Created by Song on 10/18/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <CAPKit/CAPKit.h>
#import "CAPButtonM.h"

/**The Button Widget*/
@interface CAPButtonWidget : CAPAbstractUIWidget{
    UIButton *buttonView;
    UIView *buttonMaskView;
}

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-property-synthesis"
@property (nonatomic, readonly) CAPButtonM *model;
@property (nonatomic, readonly) CAPButtonM *stableModel;
#pragma clang diagnostic pop

@end
