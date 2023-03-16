//
//  EOSTextField.m
//  EOSFramework
//
//  Created by Sam Chang on 10/12/12.
//
//

#import "EOSTextField.h"

@implementation EOSTextField

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (CGRect)textRectForBounds:(CGRect)bounds {
    CGRect contentRect = bounds;
    
    if (_model.paddingLeft) {
        contentRect.origin.x += _model.paddingLeft.value;
        contentRect.size.width -= _model.paddingLeft.value;
    }
    if (_model.paddingRight) {
        contentRect.size.width -= _model.paddingRight.value;
    }
    if (_model.paddingTop) {
        contentRect.origin.y += _model.paddingTop.value;
        contentRect.size.height -= _model.paddingTop.value;
    }
    if (_model.paddingBottom) {
        contentRect.size.height -= _model.paddingBottom.value;
    }
    
    CGRect textRect = [super textRectForBounds: contentRect];
    
    return textRect;
}

- (CGRect)editingRectForBounds:(CGRect)bounds{
    return [self textRectForBounds: bounds];
}


@end
