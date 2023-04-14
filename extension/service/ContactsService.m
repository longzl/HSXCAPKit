#import "ContactsService.h"
#import "LuaABRecord.h"

@interface ContactsService ()


@end

@implementation ContactsService


+(void)load{
    [[ESRegistry getInstance] registerService: @"ContactsService" withName: @"contacts"];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.changeWatchers = [NSMutableArray array];
    }
    return self;
}

- (BOOL) singleton{
    return YES;
}

//void handleAddressBookChange(ABAddressBookRef addressBook, CFDictionaryRef info, void *data) {
//    ContactsService *context = (__bridge ContactsService *) data;
//
//    addressBook = ABAddressBookCreateWithOptions(nil, nil);
//    if (context.addressBook) {
//        CFRelease(context.addressBook);
//    }
//    context.addressBook = addressBook;
//
//    ABAddressBookRegisterExternalChangeCallback(addressBook, handleAddressBookChange, (__bridge void *)(context));
//
//    @synchronized(context.changeWatchers){
//        NSArray *list = [NSArray arrayWithArray: context.changeWatchers];
//
//        for (LuaFunction *watcher in list) {
//            if ([watcher isValid]) {
//                [watcher executeWithoutReturnValue: context, nil];
//            }else{
//                [context.changeWatchers removeObject: watcher];
//            }
//        }
//    }
//}

- (NSArray *) getAll{
    @synchronized (self) {
        if (self.granted) {
            NSMutableArray *all = [NSMutableArray array];

            CNContactFetchRequest *request = [[CNContactFetchRequest alloc]initWithKeysToFetch:@[CNContactGivenNameKey,CNContactFamilyNameKey,CNContactPhoneNumbersKey]];
            NSError *err = nil;
            [self.store enumerateContactsWithFetchRequest:request error:&err usingBlock:^(CNContact * _Nonnull contact, BOOL * _Nonnull stop) {
                LuaABRecord *record = [[LuaABRecord alloc] initWithIdentifier: contact.identifier
                                                                  withService: self];
                [all addObject: record];
            }];

            return all;
        } else {
            DEBUG_EOS_LOG(@"Permission Denied, Or you must do this after load callback.", nil);
            return nil;
        }
    }
}

- (void) _COROUTINE_load: (LuaFunction *) func {
    switch ([CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts]) {
        case CNAuthorizationStatusAuthorized:
            if (!self.store) {
                self.store = [[CNContactStore alloc] init];
            }
            self.granted = YES;
            break;
        case CNAuthorizationStatusNotDetermined:{
            dispatch_semaphore_t dsema = dispatch_semaphore_create(0);
            if (!self.store) {
                self.store = [[CNContactStore alloc] init];
            }

            [self.store requestAccessForEntityType:CNEntityTypeContacts
                                 completionHandler:^(BOOL granted, NSError * _Nullable error) {
                self.granted = granted;
                
                if (func) {
                    [func executeWithoutReturnValue: self, [NSNumber numberWithBool: self.granted], nil];
                    [func unref];
                } else {
                    dispatch_semaphore_signal(dsema);
                }
            }];
            
            if (func) {
                return;
            }
            
            dispatch_semaphore_wait(dsema, dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10 * NSEC_PER_SEC)));
        }
            break;
        default:
            break;
    }

    if (func) {
        [func executeWithoutReturnValue: self, [NSNumber numberWithBool: self.granted], nil];
        [func unref];
    }
}

- (LuaFunctionWatcher *) addChangeWatcher:(LuaFunction *)func{
    if (![func isKindOfClass: [LuaFunction class]]) {
        return nil;
    }
    
    @synchronized(self.changeWatchers){
        [self.changeWatchers addObject: func];
    }
    
    return [[LuaFunctionWatcher alloc] initWithLuaFunction: func];
}

@end
