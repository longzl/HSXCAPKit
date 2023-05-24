@interface ControllerMap : NSObject

+ (void) bind: (NSString *) name withClass: (NSString *) clsName;
+ (NSString *) classByName: (NSString *) name;

@end
