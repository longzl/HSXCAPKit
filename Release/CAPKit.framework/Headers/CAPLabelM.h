//
//  LabelM.h
//  EOSClient2
//
//  Created by Chang Sam on 10/31/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <CAPKit/CAPKit.h>

@interface CAPLabelM : UIWidgetM

@property (nonatomic, assign) float charSpace;
@property (nonatomic, assign) float lineSpace;
@property (nonatomic, strong) NSObject *text;
@property (nonatomic, strong) NSObject *color;
@property (nonatomic, strong) NSString *fontName;
@property (nonatomic, strong) NSString *align;
@property (nonatomic, strong) NSString *verticalAlign;
@property (nonatomic, assign) float fontSize;
@property (nonatomic, assign) BOOL html;
@property (nonatomic, assign) BOOL bold;
@property (nonatomic, assign) BOOL wrap;
@property (nonatomic, assign) NSUInteger maxLines;

@end
