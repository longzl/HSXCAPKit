@interface ScriptM : NSObject

@property (nonatomic, strong) NSString *src;

+ (ScriptM *) scriptWithSrc: (NSString *) s;

@end
