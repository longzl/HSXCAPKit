@class EOSMap, EOSList;

@protocol EOSListInterface <LuaTableCompatible>

- (EOSMap *) addMap;

- (EOSList *) addList;

- (BOOL) add: (NSObject *) value;

- (BOOL) remove: (NSObject *) value;

- (NSObject *) get: (NSUInteger) idx;

- (NSObject *) removeAt: (NSUInteger) idx;

- (BOOL) clear;

- (NSUInteger) size;

- (NSString *) tostring;

- (NSArray *) tolua DEPRECATED_ATTRIBUTE;

- (NSArray *) totable;

@end
