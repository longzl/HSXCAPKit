//
//  PushTokenUpdatedEvent.h
//  EOSFramework
//
//  Created by Sam on 7/4/12.
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import "BroadcastEvent.h"

@interface WillRotateDirectionEvent : BroadcastEvent{
    NSString *direction;
}

@property (nonatomic, readonly, getter = getDirection) NSString *direction;

- (id) initWithDirection: (NSString *) direction;

@end
