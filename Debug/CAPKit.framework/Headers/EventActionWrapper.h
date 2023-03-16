@class EventDispatcher;

@interface EventActionWrapper : AbstractLuaTableCompatible {
    EventAction *wrapped;
    EventKey key;
    EventDispatcher *dispatcher;
}

- (id) initWithKey: (EventKey) k withAction: (EventAction *) action withDispatcher: (EventDispatcher *) d;

@end
