//
//  EOSCollectionHelper.h
//  EOSClient2
//
//  Created by Chang Sam on 10/24/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <CAPKit/CAPKit.h>
#import "EOSMap.h"
#import "EOSList.h"

@interface EOSCollectionHelper : NSObject

+ (EOSMap *) toEOSMap: (NSDictionary *) dic;
+ (EOSList *) toEOSList: (NSArray *) list;
+ (NSObject *) toEOS: (NSObject *) input;

@end
