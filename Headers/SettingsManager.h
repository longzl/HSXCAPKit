@interface SettingsManager : NSObject

+ (id) valueForKey: (NSString *) key;
+ (BOOL) boolForKey: (NSString *) key;


+ (NSUserDefaults *) loadUserSettings:(NSString *)aKey DEPRECATED_ATTRIBUTE;
@end
