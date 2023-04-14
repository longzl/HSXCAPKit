//
//  LuaEvent.h
//  EOSFramework
//
//  Created by Sam Chang on 8/20/12.
//
//

#import "BroadcastEvent.h"

@interface LuaEvent : BroadcastEvent{
    NSObject *object;
}

- (id)initWithKey: (NSString *) key withObject: (NSObject *) obj;

@end
