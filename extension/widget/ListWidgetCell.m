//
//  ListWidgetCell.m
//  EOSFramework
//
//  Created by Chang Sam on 11/17/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "ListWidgetCell.h"
#import "CAPListWidget.h"
#import "CAPListM.h"

@implementation ListWidgetCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle: style reuseIdentifier: reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

-(void)setFrame:(CGRect)frame{
    [super setFrame: frame];
    
    if (_widget == nil) {
        return;
    }

    CGSize size = [[_widget.pageSandbox getAppSandbox].scale getRefSize: frame.size];
    CGRect rect = [_widget measureRect: size];
    _widget->currentRect = rect;
    [_dp setValue: [NSNumber numberWithFloat: rect.size.height] forKey: @"height"];
    [_widget reloadRect];

    if (!self.listWidget.model.__row_height) {
        CGRect rect = _widget->currentRect;

        if ([[_widget.pageSandbox getAppSandbox].scale getActualLength: rect.size.height] > frame.size.height) {
            [_listWidget reloadCellAtIndexPath: _indexPath];
        }
    }

}

@end
