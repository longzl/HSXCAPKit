//
//  TextfieldM.m
//  EOSClient2
//
//  Created by Song on 10/17/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "CAPTextfieldM.h"

@implementation CAPTextfieldM

- (void) parseKeyboard: (NSString *) value {
    if (![value isKindOfClass: [NSString class]]) {
        _keyboard = UIKeyboardTypeDefault;
        return;
    }
    
    if ([value isEqualToString: @"number"]) {
        _keyboard = UIKeyboardTypeNumbersAndPunctuation;
    } else if ([value isEqualToString: @"numberpad"]){
        _keyboard = UIKeyboardTypeNumberPad;
    } else if ([value isEqualToString: @"ascii"]){
        _keyboard = UIKeyboardTypeASCIICapable;
    } else if ([value isEqualToString: @"url"]){
        _keyboard = UIKeyboardTypeURL;
    } else if ([value isEqualToString: @"tel"]){
        _keyboard = UIKeyboardTypePhonePad;
    } else if ([value isEqualToString: @"email"]){
        _keyboard = UIKeyboardTypeEmailAddress;
    } else if ([value isEqualToString: @"decimal"]){
        _keyboard = UIKeyboardTypeDecimalPad;
    } else if ([value isEqualToString: @"namephone"]){
        _keyboard = UIKeyboardTypeNamePhonePad;
    } else if ([value isEqualToString: @"twitter"]){
        _keyboard = UIKeyboardTypeTwitter;
    } else {
        _keyboard = UIKeyboardTypeDefault;
    }
}

- (NSString *) keyboardName{
    switch (_keyboard) {
        case UIKeyboardTypeNumbersAndPunctuation:
            return @"number";
        case UIKeyboardTypeNumberPad:
            return @"numberpad";
        case UIKeyboardTypeASCIICapable:
            return @"ascii";
        case UIKeyboardTypeURL:
            return @"url";
        case UIKeyboardTypePhonePad:
            return @"tel";
        case UIKeyboardTypeEmailAddress:
            return @"email";
        case UIKeyboardTypeDecimalPad:
            return @"decimal";
        case UIKeyboardTypeNamePhonePad:
            return @"namephone";
        case UIKeyboardTypeTwitter:
            return @"twitter";
        default:
            return nil;
    }
}

- (NSString *) borderStyleName{
    switch (_borderStyle) {
        case UITextBorderStyleRoundedRect:
            return @"roundrect";
        case UITextBorderStyleLine:
            return @"line";
        case UITextBorderStyleBezel:
            return @"bezel";
            
        default:
            return nil;
    }
}

- (void) parseBorderStyle: (NSString *) value{
    if (![value isKindOfClass: [NSString class]]) {
        _borderStyle = UITextBorderStyleNone;
        return;
    }
    
    if ([value isEqualToString: @"roundrect"]) {
        _borderStyle = UITextBorderStyleRoundedRect;
    } else if ([value isEqualToString: @"line"]) {
        _borderStyle = UITextBorderStyleLine;
    } else if ([value isEqualToString: @"bezel"]) {
        _borderStyle = UITextBorderStyleBezel;
    } else {
        _borderStyle = UITextBorderStyleNone;
    }
}

- (NSString *) returnTypeName{
    switch (_returnType) {
        case UIReturnKeyNext:
            return @"next";
        case UIReturnKeyDone:
            return @"done";
        case UIReturnKeyGo:
            return @"go";
        case UIReturnKeySearch:
            return @"search";
            
        default:
            return nil;
    }
}

- (void) parseReturnType: (NSString *) value{
    if (![value isKindOfClass: [NSString class]]) {
        _returnType = UIReturnKeyDefault;
        return;
    }
    
    if ([value isEqualToString: @"next"]) {
        _returnType = UIReturnKeyNext;
    }else if([value isEqualToString: @"done"]) {
        _returnType = UIReturnKeyDone;
    }else if ([value isEqualToString: @"go"]) {
        _returnType = UIReturnKeyGo;
    }else if ([value isEqualToString: @"search"]) {
        _returnType = UIReturnKeySearch;
    }else{
        _returnType = UIReturnKeyDefault;
    }
}

-(void)mergeFromDic:(NSDictionary *)dic{
    [super mergeFromDic: dic];
    
    if ([dic valueForKey: @"password"]) {
        self.password = [[dic valueForKey: @"password"] boolValue];
    }

    if ([dic valueForKey: @"keyboard"]) {
        [self parseKeyboard: [dic valueForKey: @"keyboard"]];
    }
    
    if (!self.paddingLeft) {
        self.paddingLeft = [PNum pnumWithValue: 5 withPercentage: NO];
    }
    
    if ([dic valueForKey: @"maxLength"]) {
        _maxLength = [[dic valueForKey: @"maxLength"] intValue];
    }
    
    if ([dic valueForKey: @"returnType"]) {
        [self parseReturnType: [dic valueForKey: @"returnType"]];
    }
    
    if ([dic valueForKey: @"borderStyle"]) {
        [self parseBorderStyle: [dic valueForKey: @"borderStyle"]];
    }
    
    if ([dic valueForKey: @"onReturnClick"]) {
        self.onReturnClick = [dic valueForKey: @"onReturnClick"];
    }
    
    if ([dic valueForKey: @"onDoneClick"]) {
        self.onDoneClick = [dic valueForKey: @"onDoneClick"];
    }
    
    if ([dic valueForKey: @"onblur"]) {
        self.onblur = [dic valueForKey: @"onblur"];
    }
    if ([dic valueForKey: @"onfocus"]) {
        self.onfocus = [dic valueForKey: @"onfocus"];
    }
    if ([dic valueForKey: @"placeholder"]) {
        self.placeholder = [dic valueForKey: @"placeholder"];
    }
    
    if ([dic valueForKey: @"editable"]) {
        _editable = [[dic valueForKey: @"editable"] boolValue];
    }
    
    if ([dic valueForKey: @"doneable"]) {
        _doneable = [[dic valueForKey: @"doneable"] boolValue];
    }
    
    if ([dic valueForKey: @"hideClearButton"]) {
        _hideClearButton = [[dic valueForKey: @"hideClearButton"] boolValue];
    }

    if ([dic valueForKey: @"placeholderFontSize"]) {
        _placeholderFontSize = [[dic valueForKey: @"placeholderFontSize"] floatValue];
    }

    if ([dic valueForKey: @"placeholderColor"]) {
        _placeholderColor = [dic valueForKey: @"placeholderColor"];
    }
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _doneable = NO;
        _editable = YES;
        _placeholderFontSize = NAN;
    }
    return self;
}

-(id)copyWithZone:(NSZone *)zone{
    CAPTextfieldM *m = [super copyWithZone: zone];
    m.password = _password;
    m.placeholder = _placeholder;
    m.onDoneClick = _onDoneClick;
    m.onReturnClick = _onReturnClick;
    m.keyboard = _keyboard;
    m.maxLength = _maxLength;
    m.returnType = _returnType;
    m.editable = _editable;
    m.onblur = _onblur;
    m.onfocus = _onfocus;
    m.borderStyle = _borderStyle;
    m.doneable = _doneable;
    m.hideClearButton = _hideClearButton;
    m.placeholderColor = _placeholderColor;
    m.placeholderFontSize = _placeholderFontSize;
    
    return m;
}

@end
