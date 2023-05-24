@interface DefaultSandbox : EOSMap <DefaultSandboxInterface>{
    EventDispatcher *dispatcher;
}

- (void) destroy;

- (NSString *) getScopeId;

- (int) dispatchEvent: (BaseEvent *) e;

@end
