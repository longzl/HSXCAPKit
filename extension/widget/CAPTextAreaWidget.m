//
//  TextAreaWidget.m
//  EOSClient2
//
//  Created by Chang Sam on 10/19/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "CAPTextAreaWidget.h"
#import "CAPTextAreaM.h"

@implementation CAPTextAreaWidget

+(void)load{
    [WidgetMap bind: @"textarea" withModelClassName: NSStringFromClass([CAPTextAreaM class]) withWidgetClassName: NSStringFromClass([CAPTextAreaWidget class])];
}

-(id)initWithModel:(CAPTextAreaM *)m withPageSandbox: (CAPPageSandbox *) sandbox{
    self = [super initWithModel: m withPageSandbox: sandbox];
    if (self) {
    }
    return self;
}

- (void) updateBackgroundFrame{
    [super updateBackgroundFrame];
    
    CGRect rect = backgroundImageView.frame;
    rect.origin.x = 3;
    rect.origin.y = 8;
    
    backgroundImageView.frame = rect;
}

- (void) onCreateView{
    textView = [[EOSTextView alloc] initWithFrame: [self getActualCurrentRect]];

    self.clipsToBounds = textView.clipsToBounds;

    ScreenScale *scale = [self.pageSandbox getAppSandbox].scale;
    
    textView.contentInset = UIEdgeInsetsMake(-8 + [scale getActualLength: [self.model.paddingTop pixelValue: currentRect.size.height withDefault: 0]],
                                             -8 + [scale getActualLength: [self.model.paddingLeft pixelValue: currentRect.size.width withDefault: 0]],
                                             [scale getActualLength: [self.model.paddingBottom pixelValue: currentRect.size.height withDefault: 0]],
                                             [scale getActualLength: [self.model.paddingRight pixelValue: currentRect.size.width withDefault: 0]]);

    if (self.model.hasTouchDisabled) {
        textView.userInteractionEnabled = !self.model.touchDisabled;
    }
    
    textView.editable = self.model.editable;
    //textView.editable = NO;
    
    textView.text = [self.model.text description];
    textView.placeholder = [self.model.placeholder description];
    textView.placeholderColor = [OSUtils getColorFromObject: self.model.placeholderColor
                                           withDefaultColor: [UIColor lightGrayColor]];

    textView.font = [self createFont];

    UIColor *color = [OSUtils getColor: ((CAPTextAreaM *) self.model).color withAlpha: NAN withDefaultColor: [UIColor blackColor]];
    textView.textColor = color;
        
    if (self.model.hasTouchDisabled) {
        textView.userInteractionEnabled = !self.model.touchDisabled;
    }
    
    textView.keyboardType = self.model.keyboard;
    textView.autocapitalizationType = NO;
    textView.autocorrectionType = NO;
    textView.enablesReturnKeyAutomatically = YES;
    
    textView.returnKeyType = self.model.returnType;
    textView.secureTextEntry = self.model.password;
    
    textView.delegate = self;
    
    if (self.model.doneable) {
        UIToolbar *keyboardToolbar = [[UIToolbar alloc] initWithFrame: CGRectMake(0, 0, [self getActualCurrentRect].size.width, 30)];
        keyboardToolbar.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        keyboardToolbar.barStyle = UIBarStyleBlack;
        keyboardToolbar.translucent = YES;
        UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target: self action: @selector(keyboardDoneClicked)];
        UIBarButtonItem *spaceBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemFlexibleSpace target: nil action: nil];
        keyboardToolbar.items = [NSArray arrayWithObjects: spaceBtn, doneBtn, nil];
        textView.inputAccessoryView = keyboardToolbar;
    }
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

- (void) keyboardDoneClicked{
    [textView resignFirstResponder];
    NSObject *doneClick = ((CAPTextAreaM *) self.model).onDoneClick;
    [OSUtils executeDirect: doneClick withSandbox: self.pageSandbox];
}

- (void)setData:(NSString *) data{
    if ([data isKindOfClass: [NSString class]]) {
        textView.text = data;
    }
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    [self.pageSandbox pushEditingFocus: self];
    return YES;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView{
    [self.pageSandbox removeEditingFocus: self];
    return YES;
}

- (void) textViewDidBeginEditing:(UITextView *)textField{
    [OSUtils executeDirect: self.model.onfocus withSandbox: self.pageSandbox withObject: self];
}

- (void)textViewDidEndEditing:(UITextView *)textField{
    [OSUtils executeDirect: self.model.onblur withSandbox: self.pageSandbox withObject: self];
}

- (void)textViewDidChange:(UITextView *) tview{
    NSString *text = textView.text;
    NSString *lang = [textView.textInputMode primaryLanguage];
    if ([lang isEqualToString:@"zh-Hans"]) {
        UITextRange *selectedRange = [textView markedTextRange];
        UITextPosition *position = [textView positionFromPosition:selectedRange.start offset:0];
        if (!position) {
            if (self.model.maxLength > 0 && [text length] > self.model.maxLength) {
                text = [text substringToIndex: self.model.maxLength];
                textView.text = text;
            }
        }
        else{

        }
    }
    else{
        if (self.model.maxLength > 0 && [text length] > self.model.maxLength) {
            text = [text substringToIndex: self.model.maxLength];
            textView.text = text;
        }
    }

    self.model.text = text;
    self.stableModel.text = text;
    [OSUtils executeDirect: self.model.onchange withSandbox: self.pageSandbox withObject: self];
}

-(UIView *)innerView{
    return textView;
}

- (NSObject *) getText{
    return ((CAPTextAreaM *) self.model).text;
}

- (void) setFocus{
    [OSUtils runBlockOnMain:^{
        [textView becomeFirstResponder];
    }];
}

-(void)onReload{
    [super onReload];
    
    APPLY_DIRTY_MODEL_PROP(editable, textView.editable);
    
    APPLY_DIRTY_MODEL_PROP_DO(text, {
        textView.text = [self.model.text description];
    });
    
    APPLY_DIRTY_MODEL_PROP_DO(color, {
        textView.textColor = [OSUtils getColor: self.model.color withAlpha: NAN withDefaultColor: [UIColor blackColor]];
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
        textView.placeholder = [self.model.placeholder description];
        textView.placeholderColor = [OSUtils getColorFromObject: self.model.placeholderColor
                                               withDefaultColor: [UIColor lightGrayColor]];
        [textView setNeedsDisplay];
    }

    BOOL needRefreshFont = NO;

    APPLY_DIRTY_MODEL_PROP_FLOAT_DO(fontSize, {
        needRefreshFont = YES;
    });

    APPLY_DIRTY_MODEL_PROP_DO(fontName, {
        needRefreshFont = YES;
    });

    if (needRefreshFont) {
        textView.font = [self createFont];
    }
}

- (void) clearFocus{
    [OSUtils runBlockOnMain:^{
        [textView resignFirstResponder];
    }];
}

- (void) setText: (NSObject *) txt{
    self.model.text = txt;
    
    [self reload];
}

- (void) setPlaceholder: (NSString *) txt{
    self.model.placeholder = txt;
    
    [self reload];
}

- (NSString *) getPlaceholder{
    return self.model.placeholder;
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

- (void) _LUA_setEditable: (BOOL) value{
    self.model.editable = value;
}

- (BOOL) _LUA_getEditable{
    return self.model.editable;
}

-(void)onDestroy{
    [OSUtils unRef: ((CAPTextAreaM *) self.model).onDoneClick];
    [OSUtils unRef: ((CAPTextAreaM *) self.model).onReturnClick];
    [OSUtils unRef: ((CAPTextAreaM *) self.model).onblur];
    [OSUtils unRef: ((CAPTextAreaM *) self.model).onfocus];

    [super onDestroy];
}

-(void)dealloc{
    [OSUtils runSyncBlockOnMain:^{
        textView = nil;
    }];
}

@end
