@protocol ILuaError <NSObject>

- (NSNumber *) traceException: (NSString *) appId :(NSString *) message;

@end
