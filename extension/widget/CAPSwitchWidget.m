//
//  SwitchWidget.m
//  EOSFramework
//
//  Created by Sam on 6/20/12.
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import "CAPSwitchWidget.h"
#import "CAPSwitchM.h"

@implementation CAPSwitchWidget

+(void)load{
    [WidgetMap bind: @"switch" withModelClassName: NSStringFromClass([CAPSwitchM class]) withWidgetClassName: NSStringFromClass([CAPSwitchWidget class])];
}

-(void)onCreateView{
    container = [[UIView alloc] initWithFrame: [self getActualCurrentRect]];
    switchView = [[UISwitch alloc] initWithFrame: CGRectZero];
    switchView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
    [switchView addTarget: self action: @selector(valueChanged) forControlEvents: UIControlEventValueChanged];
    switchView.on = ((CAPSwitchM *) self.model).checked;
    [container addSubview: switchView];
}

- (void) valueChanged{
    ((CAPSwitchM *) self.model).checked = switchView.on;
    
    [OSUtils executeDirect: ((CAPSwitchM *) self.model).onchange withSandbox: self.pageSandbox];
}

-(UIView *)innerView{
    return container;
}

#pragma mark Lua API Begin

- (void) _LUA_setChecked: (NSNumber *) ckd{
    if (![ckd respondsToSelector: @selector(boolValue)]) {
        return;
    }
    ((CAPSwitchM *) self.model).checked = [ckd boolValue];

    [OSUtils runBlockOnMain:^{
        switchView.on = [ckd boolValue];
    }];
}

- (NSNumber *) _LUA_getChecked{
    return [NSNumber numberWithBool: ((CAPSwitchM *) self.model).checked];
}

#pragma mark Lua API End

@end
