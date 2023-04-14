//
//  IEMailService.h
//  EOSFramework
//
//  Created by Sam on 6/19/13.
//
//

#import <CAPKit/CAPKit.h>

@protocol IEMailService <NSObject>

- (void) send: (NSDictionary *) args;

@end
