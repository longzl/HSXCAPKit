//
//  LabelWidget.m
//  EOSClient2
//
//  Created by Chang Sam on 10/19/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "CAPLabelWidget.h"
#import "CAPLabelM.h"
#import "DTCoreText.h"

@implementation CAPLabelWidget

+(void)load{
    [WidgetMap bind: @"label" withModelClassName: NSStringFromClass([CAPLabelM class]) withWidgetClassName: NSStringFromClass([CAPLabelWidget class])];
}

-(void) setPossibleAttributedText {
    NSString *text = [self.model.text description];
    if (!text) {
        labelView.text = @"";
    } else if (isnan(self.model.lineSpace) && isnan(self.model.charSpace)) {
        labelView.text = text;
    } else {
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:text];
        if (self.model.lineSpace) {
            NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
            [paraStyle setLineSpacing:self.model.lineSpace];
            
            NSTextAlignment align = NSTextAlignmentLeft;
            if ([self.model.align isEqualToString: @"left"]) {
                align = NSTextAlignmentLeft;
            }else if([self.model.align isEqualToString: @"center"]){
                align = NSTextAlignmentCenter;
            }else if([self.model.align isEqualToString: @"right"]){
                align = NSTextAlignmentRight;
            }
            
            paraStyle.alignment = align;
            [attributedString addAttribute:NSParagraphStyleAttributeName value:paraStyle range:NSMakeRange(0, [text length])];
        }
        
        if (!isnan(self.model.charSpace) && self.model.charSpace > 0) {
            [attributedString addAttribute:NSKernAttributeName value:[NSNumber numberWithFloat:self.model.charSpace] range:NSMakeRange(0, [text length])];
        }
        
        [labelView setAttributedText:attributedString];
    }
}

-(void) onCreateView{
    view = [[UIView alloc] initWithFrame: [self getActualCurrentRect]];
    view.clipsToBounds = YES;

    if (self.model.html && [self.model.text isKindOfClass: [NSString class]]) {
        attributedLabelView = [[DTAttributedLabel alloc] initWithFrame: view.bounds];
        attributedLabelView.backgroundColor = [UIColor clearColor];
        NSData *data = [(NSString *)self.model.text dataUsingEncoding:NSUTF8StringEncoding];
        NSAttributedString *attrString = [[NSAttributedString alloc] initWithHTMLData:data
                                                                   documentAttributes:NULL];
        attributedLabelView.attributedString = attrString;
        attributedLabelView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [view addSubview: attributedLabelView];
    } else {
        labelView = [[EOSLabel alloc] initWithFrame: view.bounds];
        labelView.widget = self;
        labelView.pageSandbox = self.pageSandbox;
        
        if (self.model.wrap) {
            labelView.numberOfLines = self.model.maxLines; // 0 as default
            labelView.lineBreakMode = NSLineBreakByWordWrapping;
        }
        
        if ([self.model.verticalAlign isKindOfClass: [NSString class]]) {
            if ([self.model.verticalAlign isEqualToString: @"top"]) {
                labelView.verticalAlign = VerticalAlignmentTop;
            }else if ([self.model.verticalAlign isEqualToString: @"middle"]){
                labelView.verticalAlign = VerticalAlignmentMiddle;
            }else if ([self.model.verticalAlign isEqualToString: @"bottom"]){
                labelView.verticalAlign = VerticalAlignmentBottom;
            }
        }
        
        [self setPossibleAttributedText];
        labelView.font = [self createFont];
        
        if ([self.model.align isEqualToString: @"left"]) {
            labelView.textAlignment = NSTextAlignmentLeft;
        }else if([self.model.align isEqualToString: @"center"]){
            labelView.textAlignment = NSTextAlignmentCenter;
        }else if([self.model.align isEqualToString: @"right"]){
            labelView.textAlignment = NSTextAlignmentRight;
        }
        
        UIColor *color = [OSUtils getColor: self.model.color withAlpha: NAN withDefaultColor: [UIColor blackColor]];
        labelView.textColor = color;
        labelView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        labelView.backgroundColor = [UIColor clearColor];
        [view addSubview: labelView];
    }
    
    if (self.model.hasTouchDisabled) {
        view.userInteractionEnabled = !self.model.touchDisabled;
    }else{
        view.userInteractionEnabled = NO;
    }
    
    if (self.model.backgroundAlpha == 0) {
        view.backgroundColor = [UIColor clearColor];
    }else{
        view.backgroundColor = self.backgroundColor;
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

-(id)initWithModel:(UIWidgetM *)m withPageSandbox:(CAPPageSandbox *)sandbox{
    self = [super initWithModel: m withPageSandbox: sandbox];
    if (self) {
//        [self createLabel];
    }
    
    return self;
}

- (void)setData: (NSObject *) data{
    if ([data isKindOfClass: [NSString class]]) {
        self.model.text = data;
    }
}

-(void)setViewFrame:(CGRect)rect{
    [super setViewFrame: rect];

    attributedLabelView.frame = view.bounds;
}

-(UIView *)innerView{
    return view;
}

-(CGRect)measureRect:(CGSize)parentContentSize{
    CGRect rect = [super measureRect: parentContentSize];

    @autoreleasepool {
        if (self.model.wrap && !self.model.html && self.model.text) {
            CGSize size;
            CGFloat width = [[self.pageSandbox getAppSandbox].scale getActualLength: rect.size.width];
            CGFloat height = CGFLOAT_MAX;

            UIFont *font = [self createFont];

            if (self.model.maxLines > 0) {
                height = ((CAPLabelM *) self.model).maxLines * font.lineHeight;
                if (self.model.maxLines == 1) {
                    width = CGFLOAT_MAX;
                }
            }

            NSString *value = [self.model.text description];

            NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString: value];
            NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
            paraStyle.lineBreakMode = NSLineBreakByWordWrapping;
            if (!isnan(self.model.lineSpace) && self.model.lineSpace > 0) {
                [paraStyle setLineSpacing: self.model.lineSpace];
            }

            [attributedString addAttribute: NSParagraphStyleAttributeName value: paraStyle range: NSMakeRange(0, [value length])];

            if (!isnan(self.model.charSpace) && self.model.charSpace > 0) {
                [attributedString addAttribute: NSKernAttributeName
                                         value:[NSNumber numberWithFloat: self.model.charSpace]
                                         range: NSMakeRange(0, [value length])];
            }

            if (font) {
                [attributedString addAttribute:NSFontAttributeName value: font range:NSMakeRange(0,[value length])];
            }

            CGRect rrrr = [attributedString boundingRectWithSize: CGSizeMake(width, height)
                                                         options: NSStringDrawingUsesLineFragmentOrigin
                                                         context: nil];

            size.width = ceilf([[self.pageSandbox getAppSandbox].scale getRefLength: ceilf(rrrr.size.width)]);
            size.height = ceilf([[self.pageSandbox getAppSandbox].scale getRefLength: ceilf(rrrr.size.height)]);

            if (rect.size.height < size.height) {
                rect.size.height = size.height;
            }
            if (rect.size.width < size.width) {
                rect.size.width = size.width;
            }
        } else if (self.model.wrap && self.model.html && attributedLabelView) {
            CGRect frame = [self getActualCurrentRect];
            frame.size.height = CGFLOAT_MAX;
            attributedLabelView.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
            [attributedLabelView sizeToFit];

            CGSize size = [attributedLabelView suggestedFrameSizeToFitEntireStringConstraintedToWidth: rect.size.width];

            size.width = ceilf([[self.pageSandbox getAppSandbox].scale getRefLength: size.width]);
            size.height = ceilf([[self.pageSandbox getAppSandbox].scale getRefLength: size.height]);
            
            if (rect.size.height < size.height) {
                rect.size.height = size.height;
            }
            if (rect.size.width < size.width) {
                rect.size.width = size.width;
            }
        }
    }

    return rect;
}

- (void) onReload{
    APPLY_DIRTY_MODEL_PROP_DO(text, {
        if (self.model.html && [self.stableModel.text isKindOfClass: [NSString class]]) {
            NSData *data = [(NSString *)self.model.text dataUsingEncoding:NSUTF8StringEncoding];
            NSAttributedString *attrString = [[NSAttributedString alloc] initWithHTMLData:data
                                                                       documentAttributes:NULL];
            attributedLabelView.attributedString = attrString;
        }else{
            [self setPossibleAttributedText];
        }
    });

    APPLY_DIRTY_MODEL_PROP_DO(color, {
        labelView.textColor = [OSUtils getColor: self.model.color withAlpha: NAN withDefaultColor: [UIColor blackColor]];
    });
    
    BOOL needRefreshFont = NO;

    APPLY_DIRTY_MODEL_PROP_FLOAT_DO(fontSize, {
        needRefreshFont = YES;
    });
    
    APPLY_DIRTY_MODEL_PROP_DO(fontName, {
        needRefreshFont = YES;
    });
    
    APPLY_DIRTY_MODEL_PROP_EQ_DO(bold, {
        needRefreshFont = YES;
    });
    
    if (needRefreshFont) {
        labelView.font = [self createFont];
    }
    
    APPLY_DIRTY_MODEL_PROP_DO(align, {
        if ([self.model.align isEqualToString: @"left"]) {
            labelView.textAlignment = NSTextAlignmentLeft;
        }else if([self.model.align isEqualToString: @"center"]){
            labelView.textAlignment = NSTextAlignmentCenter;
        }else if([self.model.align isEqualToString: @"right"]){
            labelView.textAlignment = NSTextAlignmentRight;
        }
    });
    
    APPLY_DIRTY_MODEL_PROP_DO(verticalAlign, {
        if ([self.model.verticalAlign isKindOfClass: [NSString class]]) {
            if ([self.model.verticalAlign isEqualToString: @"top"]) {
                labelView.verticalAlign = VerticalAlignmentTop;
            }else if ([self.model.verticalAlign isEqualToString: @"middle"]){
                labelView.verticalAlign = VerticalAlignmentMiddle;
            }else if ([self.model.verticalAlign isEqualToString: @"bottom"]){
                labelView.verticalAlign = VerticalAlignmentBottom;
            }
            
            [labelView setNeedsDisplay];
        }
    });
    
    BOOL needRefreshWrap = NO;
    
    APPLY_DIRTY_MODEL_PROP_EQ_DO(maxLines, {
        needRefreshWrap = YES;
    });
    
    APPLY_DIRTY_MODEL_PROP_EQ_DO(wrap, {
        needRefreshWrap = YES;
    });
    
    if (needRefreshWrap) {
        if (self.model.wrap) {
            labelView.numberOfLines = self.model.maxLines; // 0 as default
            labelView.lineBreakMode = NSLineBreakByWordWrapping;
        }else{
            labelView.numberOfLines = 1;
        }
    }
}

- (void) setText: (NSObject *) txt{
    ((CAPLabelM *) self.model).text = txt;
    
    [self reload];
}

- (NSObject *) getText{
    return self.model.text;
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

- (void) setLineSpace: (NSNumber *) value{
    if ([value respondsToSelector: @selector(floatValue)]) {
        self.model.lineSpace = [value floatValue];
        [self reload];
    }
}

- (float) getLineSpace{
    return self.model.lineSpace;
}

- (void) setCharSpace: (NSNumber *) value{
    if ([value respondsToSelector: @selector(floatValue)]) {
        self.model.charSpace = [value floatValue];
        [self reload];
    }
}

- (float) getCharSpace{
    return self.model.charSpace;
}

- (void) setColor: (NSObject *) color{
    self.model.color = color;

    [self reload];
}

- (NSObject *) getColor{
    return self.model.color;
}

- (void) setBold: (BOOL) value{
    self.model.bold = value;
    
    [self reload];
}

- (BOOL) getBold{
    return self.model.bold;
}

- (void) setAlign: (NSString *) value{
    if (!value || [value isKindOfClass: [NSString class]]) {
        self.model.align = value;
        [self reload];
    }
}

- (NSString *) getAlign{
    return self.model.align;
}

- (void) setVerticalAlign: (NSString *) value{
    if (!value || [value isKindOfClass: [NSString class]]) {
        self.model.verticalAlign = value;
        [self reload];
    }
}

- (NSString *) getVerticalAlign{
    return self.model.verticalAlign;
}

- (void) setMaxLines: (int) value{
    self.model.maxLines = value;
    [self reload];
}

- (BOOL) getWrap{
    return self.model.wrap;
}

- (void) setWrap: (BOOL) value{
    self.model.wrap = value;
    [self reload];
}

- (int) getMaxLines{
    return (int) self.model.maxLines;
}

@end
