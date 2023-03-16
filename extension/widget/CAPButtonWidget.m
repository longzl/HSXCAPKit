//
//  ButtonWidget.m
//  EOSClient2
//
//  Created by Song on 10/18/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "CAPButtonWidget.h"
#import "CAPButtonM.h"
#import "CJSONSerializer.h"

@implementation CAPButtonWidget

+(void)load {
    [WidgetMap bind: @"button" withModelClassName: NSStringFromClass([CAPButtonM class]) withWidgetClassName: NSStringFromClass([CAPButtonWidget class])];
}

- (void) refreshTitle{
    if (self.model.label) {
        NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc]
                                                 initWithString: [self.model.label description]];

        if (self.model.underline) {
            [attrString addAttribute: NSUnderlineStyleAttributeName
                               value: [NSNumber numberWithInteger:NSUnderlineStyleSingle]
                               range: NSMakeRange(0, [attrString length])];
        }

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

        [attrString addAttribute: NSFontAttributeName
                           value: font
                           range: NSMakeRange(0, [attrString length])];

        [attrString addAttribute: NSForegroundColorAttributeName
                           value: [OSUtils getColor: self.model.color withAlpha: NAN withDefaultColor: [UIColor blackColor]]
                           range: NSMakeRange(0, [attrString length])];

        [buttonView setAttributedTitle: attrString forState: UIControlStateNormal];
    } else {
        [buttonView setTitle: nil forState: UIControlStateNormal];
    }
}

-(void) onCreateView{
    CAPButtonM *m = (CAPButtonM *) self.model;
    CGRect actualCurrentRect = [self getActualCurrentRect];

    buttonView = [UIButton buttonWithType: UIButtonTypeCustom];
    buttonView.frame = actualCurrentRect;
    buttonView.exclusiveTouch = self.model.exclusiveTouch;

    if (!m.showsTouchWhenHighlighted && m.showsTouch) {
        buttonMaskView = [[UIView alloc] initWithFrame: CGRectMake(0, 0, actualCurrentRect.size.width, actualCurrentRect.size.height)];
        buttonMaskView.userInteractionEnabled = NO;
        buttonMaskView.backgroundColor = [UIColor colorWithWhite: 0.5 alpha: 0.5];
        buttonMaskView.alpha = 0;
        [buttonView addSubview: buttonMaskView];
    }
    if (m.hasTouchDisabled) {
        buttonView.userInteractionEnabled = !m.touchDisabled;
    }
    
    [self refreshTitle];
    
    if ([m.align isEqualToString: @"left"]) {
        buttonView.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    }else if([m.align isEqualToString: @"center"]){
        buttonView.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    }else if([m.align isEqualToString: @"right"]){
        buttonView.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    }

    if (m.showsTouchWhenHighlighted) {
        buttonView.showsTouchWhenHighlighted = YES;
    }

    [buttonView addTarget: self action: @selector(onButtonClick:) forControlEvents: UIControlEventTouchUpInside];
    
    [buttonView addTarget: self action: @selector(onButtonTouchDown) forControlEvents: UIControlEventTouchDown];
    [buttonView addTarget: self action: @selector(onButtonTouchUp) forControlEvents: UIControlEventTouchDragExit];
    [buttonView addTarget: self action: @selector(onButtonTouchDown) forControlEvents: UIControlEventTouchDragEnter];
    [buttonView addTarget: self action: @selector(onButtonTouchUp) forControlEvents: UIControlEventTouchCancel];
}

-(void)setViewFrame:(CGRect)rect{
    [super setViewFrame: rect];
    
    if (!self.model.showsTouchWhenHighlighted && self.model.showsTouch) {
        buttonMaskView.frame = CGRectMake(0, 0, rect.size.width, rect.size.height);
    }
}

- (void) onButtonTouchDown{
    if (!self.model.showsTouchWhenHighlighted && self.model.showsTouch) {
        [UIView beginAnimations: nil context: nil];
        buttonMaskView.alpha = 1;
        [UIView commitAnimations];
    }
    
    if ([self.model.onmousedown isKindOfClass: [NSString class]]) {
        [OSUtils executeDirect: self.model.onmousedown withSandbox: self.pageSandbox];
    }else if([self.model.onmousedown isKindOfClass: [LuaFunction class]]){
        LuaFunction *func = (LuaFunction *) self.model.onmousedown;
        [func executeWithoutReturnValue: self, nil];
    }
}

- (void) onButtonTouchUp{
    if (!self.model.showsTouchWhenHighlighted && self.model.showsTouch) {
        [UIView beginAnimations: nil context: nil];
        buttonMaskView.alpha = 0;
        [UIView commitAnimations];
    }
    
    if ([self.model.onmouseup isKindOfClass: [NSString class]]) {
        [OSUtils executeDirect: self.model.onmouseup withSandbox: self.pageSandbox];
    }else if([self.model.onmouseup isKindOfClass: [LuaFunction class]]){
        LuaFunction *func = (LuaFunction *) self.model.onmouseup;
        [func executeWithoutReturnValue: self, nil];
    }
}

- (void) onButtonClick: (UIButton *) btn{
    [self onButtonTouchUp];

    BLYLogInfo(@"[%@.%@] onclick %@", [self.pageSandbox getAppId], [self.pageSandbox getPageId], self);

    if ([self.model.onclick isKindOfClass: [NSString class]]) {
        [OSUtils executeDirect: self.model.onclick withSandbox: self.pageSandbox];
    }else if([self.model.onclick isKindOfClass: [LuaFunction class]]){
        LuaFunction *func = (LuaFunction *) self.model.onclick;
        [func executeWithoutReturnValue: self, nil];
    }

}

-(void)onReload{
    BOOL needRefreshTitle = NO;
    
    APPLY_DIRTY_MODEL_PROP_DO(label, {
        needRefreshTitle = YES;
    });

    APPLY_DIRTY_MODEL_PROP_DO(color, {
        needRefreshTitle = YES;
    });

    APPLY_DIRTY_MODEL_PROP_EQ_DO(underline, {
        needRefreshTitle = YES;
    });

    APPLY_DIRTY_MODEL_PROP_FLOAT_DO(fontSize, {
        needRefreshTitle = YES;
    });

    APPLY_DIRTY_MODEL_PROP_EQ_DO(bold, {
        needRefreshTitle = YES;
    });

    APPLY_DIRTY_MODEL_PROP_DO(fontName, {
        needRefreshTitle = YES;
    });

    if (needRefreshTitle) {
        [self refreshTitle];
    }
}

- (void) setFontSize: (NSNumber *) value{
    if ([value respondsToSelector: @selector(floatValue)]) {
        self.model.fontSize = [value floatValue];
        [self reload];
    }
}

- (float) getFontSize{
    return self.model.fontSize;
}

#pragma mark Lua API Begin

- (void) _LUA_setOnclick: (NSObject *) value{
    self.model.onclick = value;
}

- (NSObject *) _LUA_getOnclick{
    return self.model.onclick;
}

- (void) _LUA_setOnmousedown: (NSObject *) value{
    self.model.onmousedown = value;
}

- (NSObject *) _LUA_getOnmousedown{
    return self.model.onmousedown;
}

- (void) _LUA_setOnmouseup: (NSObject *) value{
    self.model.onmouseup = value;
}

- (NSObject *) _LUA_getOnmouseup{
    return self.model.onmouseup;
}

- (void) _LUA_setLabel: (NSObject *) value{
    self.model.label = value;
    
    [self reload];
}

- (NSObject *) _LUA_getLabel{
    return self.model.label;
}

- (void) _LUA_setColor: (NSObject *) value{
    self.model.color = value;
    
    [self reload];
}

- (NSObject *) getColor{
    return self.model.color;
}

- (BOOL) getUnderline{
    return self.model.underline;
}

- (void) setUnderline: (BOOL) value{
    self.model.underline = value;
    [self reload];
}

#pragma mark Lua API End

-(UIView *)innerView{
    return buttonView;
}

-(void)onDestroy{
    [super onDestroy];
    
    [OSUtils unRef: self.model.onclick];
    [OSUtils unRef: self.model.onmouseup];
    [OSUtils unRef: self.model.onmousedown];
}

@end
