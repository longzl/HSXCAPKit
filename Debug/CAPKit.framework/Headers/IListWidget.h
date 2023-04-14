//
//  IListWidget.h
//  EOSFramework
//
//  Created by Sam Chang on 3/21/12.
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import <CAPKit/CAPKit.h>

@protocol IListWidget <NSObject>

- (void) setDataProvider: (id) data DEPRECATED_ATTRIBUTE;

- (void) scrollToIndexByTitle: (NSString *) title DEPRECATED_ATTRIBUTE;
- (void) scrollToIndexByTitle: (NSString *) title : (NSNumber *) animated DEPRECATED_ATTRIBUTE;

- (void) scrollTo: (NSNumber *) section;
- (void) scrollTo: (NSNumber *) section : (NSNumber *) row;
- (void) scrollTo: (NSNumber *) section : (NSNumber *) row : (NSNumber *) animated;

- (void) reload: (NSNumber *) section : (NSNumber *) row;

- (void) closeDragDown;

@end
