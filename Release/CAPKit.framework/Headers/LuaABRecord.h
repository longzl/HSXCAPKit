#import <Foundation/Foundation.h>
#import <CAPKit/CAPKit.h>
#import "ContactsService.h"

@import AddressBook;

@interface LuaABRecord : AbstractLuaTableCompatible

@property (nonatomic, strong) ContactsService *service;
@property (nonatomic, strong) NSString *identifier;

- (instancetype) initWithIdentifier: (NSString *) identifier
                        withService: (ContactsService *) service;
@end
