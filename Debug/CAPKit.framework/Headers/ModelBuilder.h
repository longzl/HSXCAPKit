//
//  ModelBuilder.h
//  EOSClient2
//
//  Created by Chang Sam on 10/19/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CAPKit/UIWidgetM.h>
#import <CAPKit/CAPViewM.h>

@class CAPPageM;

@interface ModelBuilder : NSObject

+ (UIWidgetM *) buildModel: (NSDictionary *) dic;

+ (CAPViewM *) buildModelFromArray: (NSArray *) list;

+ (CAPPageM *) buildPage: (NSDictionary *) dic;
+ (CAPPageM *) buildPageFromURL: (NSURL *) pageURL;

@end
