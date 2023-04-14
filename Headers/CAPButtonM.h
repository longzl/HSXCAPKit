//
//  ButtonM.h
//  EOSClient2
//
//  Created by Song on 10/17/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <CAPKit/CAPKit.h>

@interface CAPButtonM : UIWidgetM

@property (nonatomic, strong) NSObject *label;
@property (nonatomic, strong) NSObject *onclick;
@property (nonatomic, strong) NSObject *onmousedown;
@property (nonatomic, strong) NSObject *onmouseup;
@property (nonatomic, strong) NSObject *color;
@property (nonatomic, strong) NSString *fontName;
@property (nonatomic, strong) NSString *align;
@property (nonatomic, assign) float fontSize;
@property (nonatomic, assign) BOOL bold;
@property (nonatomic, assign) BOOL underline;
@property (nonatomic, assign) BOOL showsTouch;

//ios spec
@property (nonatomic, assign) BOOL exclusiveTouch;
@property (nonatomic, assign) BOOL showsTouchWhenHighlighted;

@end
