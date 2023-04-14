#import "BroadcastEvent.h"

@interface KeyBoardRectChangedEvent : BroadcastEvent {
    CGRect rect;
}

- (id) initWithRect: (CGRect) value;

@end
