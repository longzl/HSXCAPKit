@interface EventDispatcher : NSObject{
    NSMutableDictionary *eventsMap;
}

- (int) dispatchEvent: (BaseEvent *) e;

- (EventActionWrapper *) bind: (EventKey) key action: (EventAction *) action;

- (void) unbind: (EventKey) key action: (EventAction *) action;

@end
