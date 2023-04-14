//
//  TextAreaWidget.h
//  EOSClient2
//
//  Created by Chang Sam on 10/19/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CAPKit/CAPKit.h>

#import "ITextAreaWidget.h"
#import "EOSTextView.h"
#import "CAPTextAreaM.h"

@interface CAPTextAreaWidget : CAPAbstractUIWidget <ITextAreaWidget, UITextViewDelegate>{
    EOSTextView *textView;
}

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-property-synthesis"
@property (nonatomic, readonly) CAPTextAreaM *model;
@property (nonatomic, readonly) CAPTextAreaM *stableModel;
#pragma clang diagnostic pop
@end
