#import "ContactsService.h"
#import "LuaABRecord.h"

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

void handleAddressBookChange(ABAddressBookRef addressBook, CFDictionaryRef info, void *data) {
    ContactsService *context = (__bridge ContactsService *) data;

    addressBook = ABAddressBookCreateWithOptions(nil, nil);
    if (context.addressBook) {
        CFRelease(context.addressBook);
    }
    context.addressBook = addressBook;

    ABAddressBookRegisterExternalChangeCallback(addressBook, handleAddressBookChange, (__bridge void *)(context));

    @synchronized(context.changeWatchers){
        NSArray *list = [NSArray arrayWithArray: context.changeWatchers];
        
        for (LuaFunction *watcher in list) {
            if ([watcher isValid]) {
                [watcher executeWithoutReturnValue: context, nil];
            }else{
                [context.changeWatchers removeObject: watcher];
            }
        }
    }
}

- (NSArray *) getAll{
    @synchronized (self) {
        if (self.addressBook && self.granted) {
            NSMutableArray *all = [NSMutableArray array];

            CFArrayRef personArray = ABAddressBookCopyArrayOfAllPeople(self.addressBook);
            CFIndex count = ABAddressBookGetPersonCount(self.addressBook);
            for (int i = 0; i < count; i++){
                ABRecordRef personRef = CFArrayGetValueAtIndex(personArray, i);
                LuaABRecord *record = [[LuaABRecord alloc] initWithRecordID: ABRecordGetRecordID(personRef)
                                                                withService: self];
                [all addObject: record];
            }
            if (personArray) {
                CFRelease(personArray);
            }

            return all;
        } else {
            NSLog(@"Permission Denied, Or you must do this after load callback.");
            return nil;
        }
    }
}

- (void) _COROUTINE_load: (LuaFunction *) func {
    if (self.addressBook && self.granted) {
        if (func) {
            [func executeWithoutReturnValue: self, [NSNumber numberWithBool: YES], nil];
            [func unref];
        }

        return;
    }

    dispatch_semaphore_t dsema = dispatch_semaphore_create(0);

    ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(nil, nil);

    if(addressBook) {
        ABAddressBookRegisterExternalChangeCallback(addressBook, handleAddressBookChange, (__bridge void *)(self));

        ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error) {
            if (self.addressBook) {
                CFRelease(self.addressBook);
                self.addressBook = nil;
            }
            self.addressBook = addressBook;

            self.granted = granted;

            dispatch_semaphore_signal(dsema);
        });

        dispatch_semaphore_wait(dsema, DISPATCH_TIME_FOREVER);
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
