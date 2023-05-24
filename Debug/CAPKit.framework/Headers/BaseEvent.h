
@interface BaseEvent : AbstractLuaTableCompatible

@property (nonatomic, readonly) BOOL broadcast;
@property (nonatomic, readonly) BOOL propagationStopped;
@property (nonatomic, readonly) EventKey key;

- (id) initWithKey: (EventKey) k withBroadcast: (BOOL) isBroadcast;
+ (id) eventWithKey: (EventKey) k withBroadcast: (BOOL) isBroadcast;
- (id) initWithKey: (EventKey) k;

- (void) stopPropagation;

+ (id) event;


@end
