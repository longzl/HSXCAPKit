#import "BroadcastEvent.h"

@interface KeyBoardRectWillChangeEvent : BroadcastEvent {
    CGRect rect;
}

- (id) initWithRect: (CGRect) value;

@end
