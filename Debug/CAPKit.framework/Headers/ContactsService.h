#import <CAPKit/CAPKit.h>
#import <Contacts/Contacts.h>

@import AddressBook;

@interface ContactsService : AbstractLuaTableCompatible <IService, LuaTableCompatible>

@property (nonatomic, strong) CNContactStore *store;

@property (nonatomic, strong) NSMutableArray *changeWatchers;
@property (nonatomic, assign) BOOL granted;
@property (nonatomic, readonly, getter = getAll) NSArray *all;

- (LuaFunctionWatcher *) addChangeWatcher:(LuaFunction *)func;

@end
