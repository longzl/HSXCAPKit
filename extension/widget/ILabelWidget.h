//
//  ILabelWidget.h
//  EOSFramework
//
//  Created by Sam Chang on 3/21/12.
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import <CAPKit/CAPKit.h>

@protocol ILabelWidget <IAbstractUIWidget>

- (void) setText: (NSObject *) txt;
- (NSObject *) getText;

@end
