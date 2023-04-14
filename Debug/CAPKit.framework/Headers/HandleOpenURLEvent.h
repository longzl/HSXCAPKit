//
//  HandleOpenURLEvent.h
//  EOSFramework
//
//  Created by Sam Chang on 10/8/12.
//
//

#import "BroadcastEvent.h"

@interface HandleOpenURLEvent : BroadcastEvent{
    NSString *url;
}

@property (nonatomic, readonly, getter = getUrl) NSString *url;

- (id) initWithURLString: (NSString *) value;

@end
