#import <CAPKit/CAPKit.h>
#import "lua.h"

@import AddressBook;

@interface ContactsService : AbstractLuaTableCompatible <IService, LuaTableCompatible>

@property (nonatomic, assign) ABAddressBookRef addressBook;

@property (nonatomic, strong) NSMutableArray *changeWatchers;
@property (nonatomic, assign) BOOL granted;
@property (nonatomic, readonly, getter = getAll) NSArray *all;

- (LuaFunctionWatcher *) addChangeWatcher:(LuaFunction *)func;

@end
