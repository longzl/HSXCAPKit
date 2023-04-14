//
//  PushTokenUpdatedEvent.h
//  EOSFramework
//
//  Created by Sam on 7/4/12.
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import "BroadcastEvent.h"

@interface PushTokenUpdatedEvent : BroadcastEvent{
    NSString *token;
}

@property (nonatomic, readonly, getter = getToken) NSString *token;

- (id) initWithToken: (NSString *) token;

@end
