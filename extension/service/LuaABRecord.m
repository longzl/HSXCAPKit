#import "LuaABRecord.h"

@implementation LuaABRecord

- (instancetype) initWithRecordID: (ABRecordID) recordID
                      withService: (ContactsService *) service {
    self = [super init];
    if (self) {
        self.recordID = recordID;
        self.service = service;
    }
    return self;
}

- (NSString *) getFullName{
    @synchronized (self.service) {
        ABRecordRef recordRef = ABAddressBookGetPersonWithRecordID(self.service.addressBook, self.recordID);

        CFStringRef name = ABRecordCopyCompositeName(recordRef);

        if (name == NULL){
            return @"";
        }

        NSString* ret = (__bridge NSString *) name;

        CFRelease(name);
        
        return ret;
    }
}

- (NSArray *) getPhones{
    @synchronized (self.service) {
        ABRecordRef recordRef = ABAddressBookGetPersonWithRecordID(self.service.addressBook, self.recordID);

        NSMutableArray *list = [NSMutableArray array];
        ABMultiValueRef values = (ABMultiValueRef) ABRecordCopyValue(recordRef, kABPersonPhoneProperty);

        if (values) {
            CFIndex valueCount = ABMultiValueGetCount(values);
            for(int j = 0 ; j < valueCount; j++) {
                CFStringRef value =  ABMultiValueCopyValueAtIndex(values, j);
                [list addObject: (__bridge NSString *) value];
            }
            CFRelease(values);
        }
        
        return list;
    }
}

- (void) fillLuaTable: (LuaTable *) tb withKey: (NSString *) key withRef: (ABRecordRef) recordRef withPropertyID: (ABPropertyID) propertyID{
    CFTypeRef value = ABRecordCopyValue(recordRef, propertyID);
    if (value) {
        if (CFGetTypeID(value) == CFStringGetTypeID()) {
            [tb.map setValue: (__bridge NSString *) value forKey: key];
        } else if (CFGetTypeID(value) == CFDateGetTypeID()) {
            [tb.map setValue: [NSNumber numberWithFloat: [(__bridge NSDate *) value timeIntervalSince1970]] forKey: key];
        } else {
            //may crash on different type of values.
            ABMultiValueRef values = (ABMultiValueRef) value;
            if (values) {
                CFIndex valueCount = ABMultiValueGetCount(values);
                NSMutableArray *list = [NSMutableArray arrayWithCapacity: valueCount];
                for(int j = 0 ; j < valueCount; j++) {
                    CFStringRef value =  ABMultiValueCopyValueAtIndex(values, j);
                    [list addObject: (__bridge NSString *) value];
                }
                
                if ([list count] == 1) {
                    [tb.map setValue: [list firstObject] forKey: key];
                } else if ([list count] > 1){
                    [tb.map setValue: list forKey: key];
                }
            }
        }
        CFRelease(value);
    }
}

-(LuaTable *)toLuaTable{
    LuaTable *tb = [[LuaTable alloc] init];

    @synchronized (self.service) {
        ABRecordRef recordRef = ABAddressBookGetPersonWithRecordID(self.service.addressBook, self.recordID);

        [self fillLuaTable: tb withKey: @"phone" withRef: recordRef withPropertyID: kABPersonPhoneProperty];
        [self fillLuaTable: tb withKey: @"firstName" withRef: recordRef withPropertyID: kABPersonFirstNameProperty];
        [self fillLuaTable: tb withKey: @"lastName" withRef: recordRef withPropertyID: kABPersonLastNameProperty];
        [self fillLuaTable: tb withKey: @"middleName" withRef: recordRef withPropertyID: kABPersonMiddleNameProperty];
        [self fillLuaTable: tb withKey: @"prefix" withRef: recordRef withPropertyID: kABPersonPrefixProperty];
        [self fillLuaTable: tb withKey: @"suffix" withRef: recordRef withPropertyID: kABPersonSuffixProperty];
        [self fillLuaTable: tb withKey: @"nickname" withRef: recordRef withPropertyID: kABPersonNicknameProperty];
        [self fillLuaTable: tb withKey: @"firstNamePhonetic" withRef: recordRef withPropertyID: kABPersonFirstNamePhoneticProperty];
        [self fillLuaTable: tb withKey: @"lastNamePhonetic" withRef: recordRef withPropertyID: kABPersonLastNamePhoneticProperty];
        [self fillLuaTable: tb withKey: @"middleNamePhonetic" withRef: recordRef withPropertyID: kABPersonMiddleNamePhoneticProperty];
        [self fillLuaTable: tb withKey: @"organization" withRef: recordRef withPropertyID: kABPersonOrganizationProperty];
        [self fillLuaTable: tb withKey: @"jobTitle" withRef: recordRef withPropertyID: kABPersonJobTitleProperty];
        [self fillLuaTable: tb withKey: @"department" withRef: recordRef withPropertyID: kABPersonDepartmentProperty];
        [self fillLuaTable: tb withKey: @"email" withRef: recordRef withPropertyID: kABPersonEmailProperty];
        [self fillLuaTable: tb withKey: @"birthday" withRef: recordRef withPropertyID: kABPersonBirthdayProperty];
        [self fillLuaTable: tb withKey: @"note" withRef: recordRef withPropertyID: kABPersonNoteProperty];
        [self fillLuaTable: tb withKey: @"creationDate" withRef: recordRef withPropertyID: kABPersonCreationDateProperty];
        [self fillLuaTable: tb withKey: @"modificationDate" withRef: recordRef withPropertyID: kABPersonModificationDateProperty];
    }

    return tb;
}

@end
