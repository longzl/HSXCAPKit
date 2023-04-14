@interface EventAction : NSObject{
}

- (void) perform: (BaseEvent *) e;

@end
