//
//  PushNotificationEvent.h
//  EOSFramework
//
//  Created by Sam on 7/5/12.
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import "BroadcastEvent.h"

@interface PushNotificationEvent : BroadcastEvent{
    NSDictionary *userInfo;
}

@property (nonatomic, readonly, getter = getAlert) NSString *alert;
@property (nonatomic, readonly, getter = getBadge) NSString *badge;
@property (nonatomic, readonly, getter = getBody) NSObject *body;

- (id) initWithUserInfo: (NSDictionary *) dic;
@end
