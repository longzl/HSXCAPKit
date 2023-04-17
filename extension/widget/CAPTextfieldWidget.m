//
//  TextfieldWidget.m
//  EOSClient2
//
//  Created by Song on 10/18/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "CAPTextfieldWidget.h"
#import "CAPTextfieldM.h"

@implementation CAPTextfieldWidget

+(void)load{
    [WidgetMap bind: @"textfield" withModelClassName: NSStringFromClass([CAPTextfieldM class]) withWidgetClassName: NSStringFromClass([CAPTextfieldWidget class])];
}

-(void)onReload{
    [super onReload];
    
    APPLY_DIRTY_MODEL_PROP(password, textfieldView.secureTextEntry);
    APPLY_DIRTY_MODEL_PROP(keyboard, textfieldView.keyboardType);
    
    APPLY_DIRTY_MODEL_PROP_DO(align, {
        if ([self.model.align isEqualToString: @"right"]) {
            textfieldView.textAlignment = NSTextAlignmentRight;
        } else if ([self.model.align isEqualToString: @"center"]){
            textfieldView.textAlignment = NSTextAlignmentCenter;
        } else {
            textfieldView.textAlignment = NSTextAlignmentLeft;
        }
    });

    BOOL needReloadPlaceholder = NO;
    
    APPLY_DIRTY_MODEL_PROP_DO(placeholder, {
        needReloadPlaceholder = YES;
    });
    APPLY_DIRTY_MODEL_PROP_FLOAT_DO(placeholderFontSize, {
        needReloadPlaceholder = YES;
    });
    APPLY_DIRTY_MODEL_PROP_DO(placeholderColor, {
        needReloadPlaceholder = YES;
    });

    if (needReloadPlaceholder) {
        [self reloadPlaceholder];
    }

    APPLY_DIRTY_MODEL_PROP_DO(color, {
        textfieldView.textColor = [OSUtils getColor: self.model.color withAlpha: NAN withDefaultColor: [UIColor blackColor]];
    });
    
    BOOL needRefreshFont = NO;

    APPLY_DIRTY_MODEL_PROP_FLOAT_DO(fontSize, {
        needRefreshFont = YES;
    });

    APPLY_DIRTY_MODEL_PROP_DO(fontName, {
        needRefreshFont = YES;
    });
    
    if (needRefreshFont) {
        textfieldView.font = [self createFont];
    }
    
    APPLY_DIRTY_MODEL_PROP(editable, textfieldView.enabled);
    APPLY_DIRTY_MODEL_PROP(borderStyle, textfieldView.borderStyle);

    APPLY_DIRTY_MODEL_PROP_DO(text, {
        textfieldView.text = [self.model.text description];
    });
}

- (UIFont *) createFont{
    float size = self.model.fontSize;
    if (isnan(size) || size == 0) {
        size = [UIFont labelFontSize];
    }
    size = [[self.pageSandbox getAppSandbox].scale getFontSize: size];

    UIFont *font = nil;

    if (self.model.fontName != nil) {
        font = [UIFont fontWithName: self.model.fontName size: size];
    }else{
        NSString *defaultFontName = [self.pageSandbox getDefaultFontName];
        if (defaultFontName) {
            font = [UIFont fontWithName: defaultFontName size: size];
        } else {
            if (self.model.bold) {
                font = [UIFont boldSystemFontOfSize: size];
            }else{
                font = [UIFont systemFontOfSize: size];
            }
        }
    }

    return font;
}

- (void) reloadPlaceholder{
    if (isnan(self.model.placeholderFontSize) && !self.model.placeholderColor) {
        textfieldView.attributedPlaceholder = nil;
        textfieldView.placeholder = self.model.placeholder;
    } else {
        NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString: self.model.placeholder];
        if (!isnan(self.model.placeholderFontSize)) {
            [attStr addAttribute: NSFontAttributeName
                           value: [UIFont systemFontOfSize: self.model.placeholderFontSize]
                           range: NSMakeRange(0, [self.model.placeholder length])];
        }
        if (self.model.placeholderColor) {
            [attStr addAttribute: NSForegroundColorAttributeName
                           value: [OSUtils getColorFromObject: self.model.placeholderColor
                                             withDefaultColor: [UIColor lightGrayColor]]
                           range: NSMakeRange(0, [self.model.placeholder length])];
        }
        textfieldView.placeholder = nil;
        textfieldView.attributedPlaceholder = attStr;
    }
}

- (void) onCreateView{
    CAPTextfieldM *m = (CAPTextfieldM *) self.model;
    textfieldView = [[EOSTextField alloc] initWithFrame: [self getActualCurrentRect]];
    textfieldView.model = m;
    textfieldView.enabled = m.editable;

    [textfieldView addTarget: self action: @selector(textFieldDidChange:) forControlEvents: UIControlEventEditingChanged];
    
    textfieldView.text = [m.text description];
    textfieldView.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;

    [self reloadPlaceholder];

    if (focus) {
        [textfieldView becomeFirstResponder];
    }

    textfieldView.font = [self createFont];
    
    textfieldView.textColor = [OSUtils getColor: m.color withAlpha: NAN withDefaultColor: [UIColor blackColor]];
    
    if (m.hasTouchDisabled) {
        textfieldView.userInteractionEnabled = !m.touchDisabled;
    }

    if (m.keyboard == UIKeyboardTypeNumbersAndPunctuation && [self.pageSandbox.model.schema isEqualToString: @"v1"]) {
        m.keyboard = UIKeyboardTypeNumberPad;
    }
    
    if ([self.model.align isEqualToString: @"right"]) {
        textfieldView.textAlignment = NSTextAlignmentRight;
    } else if ([self.model.align isEqualToString: @"center"]){
        textfieldView.textAlignment = NSTextAlignmentCenter;
    } else {
        textfieldView.textAlignment = NSTextAlignmentLeft;
    }

    textfieldView.keyboardType = m.keyboard;
    textfieldView.autocapitalizationType = NO;
    textfieldView.autocorrectionType = NO;
    textfieldView.adjustsFontSizeToFitWidth = YES;
    textfieldView.enablesReturnKeyAutomatically = YES;
    
    textfieldView.returnKeyType = m.returnType;
    
    textfieldView.clearButtonMode = m.hideClearButton ? UITextFieldViewModeNever : UITextFieldViewModeWhileEditing;
    textfieldView.secureTextEntry = m.password;
    textfieldView.borderStyle = m.borderStyle;
    textfieldView.delegate = self;
    
    if (self.model.doneable) {
        UIToolbar *keyboardToolbar = [[UIToolbar alloc] initWithFrame: CGRectMake(0, 0, [self getActualCurrentRect].size.width, 30)];
        keyboardToolbar.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        keyboardToolbar.barStyle = UIBarStyleBlack;
        keyboardToolbar.translucent = YES;
        UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target: self action: @selector(keyboardDoneClicked)];
        UIBarButtonItem *spaceBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemFlexibleSpace target: nil action: nil];
        keyboardToolbar.items = [NSArray arrayWithObjects: spaceBtn, doneBtn, nil];
        textfieldView.inputAccessoryView = keyboardToolbar;
    }
}

- (void)setData:(NSString *) data{
    if ([data isKindOfClass: [NSString class]]) {
        textfieldView.text = data;
    }
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    [self.pageSandbox pushEditingFocus: self];
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    [OSUtils executeDirect: self.model.onfocus withSandbox: self.pageSandbox withObject: self];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textfieldView resignFirstResponder];
    NSObject *onReturnClick = ((CAPTextfieldM *) self.model).onReturnClick;
    [OSUtils executeDirect: onReturnClick withSandbox: self.pageSandbox];
    return YES;
}

- (void)textFieldDidChange :(NSNotification *)obj {
    NSString *text = textfieldView.text;
    NSString *lang = [textfieldView.textInputMode primaryLanguage];
    if ([lang isEqualToString:@"zh-Hans"]) {
        UITextRange *selectedRange = [textfieldView markedTextRange];
        UITextPosition *position = [textfieldView positionFromPosition:selectedRange.start offset:0];
        if (!position) {
            if (self.model.maxLength > 0 && [text length] > self.model.maxLength) {
                text = [text substringToIndex: self.model.maxLength];
                textfieldView.text = text;
            }
        }
        else{

        }
    }
    else{
        if (self.model.maxLength > 0 && [text length] > self.model.maxLength) {
            text = [text substringToIndex: self.model.maxLength];
            textfieldView.text = text;
        }
    }

    self.model.text = text;
    self.stableModel.text = text;
    [OSUtils executeDirect: self.model.onchange withSandbox: self.pageSandbox withObject: self];
}

-(BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    [self.pageSandbox removeEditingFocus: self];
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    [OSUtils executeDirect: self.model.onblur withSandbox: self.pageSandbox withObject: self];
}

-(void)setViewFrame:(CGRect)rect{
    [super setViewFrame: rect];
    
//    textfieldView.inputAccessoryView.frame = CGRectMake(0, 0, rect.size.width, 44);
}

- (void) keyboardDoneClicked{
    [textfieldView resignFirstResponder];
    NSObject *doneClick = ((CAPTextfieldM *) self.model).onDoneClick;
    [OSUtils executeDirect: doneClick withSandbox: self.pageSandbox];
}

-(UIView *)innerView{
    return textfieldView;
}

#pragma mark Lua API Begin
- (NSObject *) getText{    
    return ((CAPTextfieldM *) self.model).text;
}

- (void) _LUA_setOnfocus: (NSObject *) onfocus{
    self.model.onfocus = onfocus;
}

- (NSObject *) _LUA_getOnfocus{
    return self.model.onfocus;
}

- (void) _LUA_setOnblur: (NSObject *) onblur{
    self.model.onblur = onblur;
}

- (NSObject *) _LUA_getOnblur{
    return self.model.onblur;
}

- (void) setFocus{
    focus = YES;
    [OSUtils runBlockOnMain:^{
        [textfieldView becomeFirstResponder];
    }];
}

- (void) clearFocus{
    focus = NO;
    [OSUtils runBlockOnMain:^{
        [textfieldView resignFirstResponder];
    }];
}

- (void) setText: (NSObject *) txt{
    ((CAPTextfieldM *) self.model).text = txt;
    [OSUtils runBlockOnMain:^{
        textfieldView.text = [txt description];
    }];
}

- (void) setPlaceholder: (NSString *) txt{
    ((CAPTextfieldM *) self.model).placeholder = txt;
    
    [self reload];
}

- (NSString *) getPlaceholder{
    return ((CAPTextfieldM *) self.model).placeholder;
}

- (void) setOnDoneClick: (NSObject *) action{
    ((CAPTextfieldM *) self.model).onDoneClick = action;
}

- (NSObject *) getOnDoneClick{
    return ((CAPTextfieldM *) self.model).onDoneClick;
}

- (void) setOnReturnClick: (NSObject *) action{
    ((CAPTextfieldM *) self.model).onReturnClick = action;
}

- (NSObject *) getOnReturnClick{
    return ((CAPTextfieldM *) self.model).onReturnClick;
}

- (void) setPassword: (NSNumber *) value{
    if ([value respondsToSelector: @selector(boolValue)]) {
        self.model.password = [value boolValue];
        
        [self reload];
    }
}

- (NSNumber *) getPassword{
    return [NSNumber numberWithBool: self.model.password];
}

- (void) setKeyboard: (NSString *) value {
    [self.model parseKeyboard: value];
    [self reload];
}

- (NSString *) getKeyboard{
    return [self.model keyboardName];
}

- (void) setBorderStyle: (NSString *) value {
    [self.model parseBorderStyle: value];
    [self reload];
}

- (NSString *) getBorderStyle{
    return [self.model borderStyleName];
}

- (void) setReturnType: (NSString *) value {
    [self.model parseReturnType: value];
    [self reload];
}

- (NSString *) getReturnType{
    return [self.model returnTypeName];
}

- (void) setColor: (NSObject *) value {
    self.model.color = value;
    [self reload];
}

- (NSObject *) getColor{
    return self.model.color;
}

- (void) setFontSize: (NSNumber *) value{
    if ([value respondsToSelector: @selector(floatValue)]) {
        self.model.fontSize = [value floatValue];
        [self reload];
    }
}

- (NSNumber *) getFontSize{
    return [NSNumber numberWithFloat: self.model.fontSize];
}

- (void) setFontName: (NSString *) value{
    self.model.fontName = value;
    [self reload];
}

- (NSString *) getFontName{
    return self.model.fontName;
}

- (void) setEditable: (NSNumber *) value {
    if ([value respondsToSelector: @selector(boolValue)]) {
        self.model.editable = [value boolValue];
        [self reload];
    }
}

- (NSNumber *) getEditable{
    return [NSNumber numberWithBool: self.model.editable];
}

#pragma mark Lua API End

-(void)onDestroy{    
    [OSUtils unRef: ((CAPTextfieldM *) self.model).onReturnClick];
    [OSUtils unRef: ((CAPTextfieldM *) self.model).onDoneClick];
    [OSUtils unRef: ((CAPTextfieldM *) self.model).onblur];
    [OSUtils unRef: ((CAPTextfieldM *) self.model).onfocus];
    
    [[NSNotificationCenter defaultCenter] removeObserver: self];

    [super onDestroy];
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver: self];
}
@end
