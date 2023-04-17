#import <Foundation/Foundation.h>
#import <CAPKit/CAPKit.h>
#import "ContactsService.h"

@import AddressBook;

@interface LuaABRecord : AbstractLuaTableCompatible

@property (nonatomic, strong) ContactsService *service;
@property (nonatomic, assign) ABRecordID recordID;

- (instancetype) initWithRecordID: (ABRecordID) recordID
                      withService: (ContactsService *) service;
@end
