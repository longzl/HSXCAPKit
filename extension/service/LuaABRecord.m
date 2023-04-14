#import "LuaABRecord.h"

@implementation LuaABRecord

- (instancetype) initWithIdentifier: (NSString *) identifier
                        withService: (ContactsService *) service {
    self = [super init];
    if (self) {
        self.identifier = identifier;
        self.service = service;
    }
    return self;
}

- (NSString *) getFullName{
    @synchronized (self.service) {
        NSError *err = nil;
        CNContact *contact = [self.service.store unifiedContactWithIdentifier: self.identifier
                                                                  keysToFetch: @[[CNContactFormatter descriptorForRequiredKeysForStyle:CNContactFormatterStyleFullName]]
                                                                        error: &err];
        if (err) {
            NSLog(@"%@", err);
            return nil;
        }
        
        return [CNContactFormatter stringFromContact:contact style:CNContactFormatterStyleFullName];
    }
}

- (NSArray *) getPhones{
    @synchronized (self.service) {
        NSError *err = nil;
        CNContact *contact = [self.service.store unifiedContactWithIdentifier: self.identifier
                                                                  keysToFetch: @[CNContactPhoneNumbersKey]
                                                                        error: &err];
        if (err) {
            NSLog(@"%@", err);
            return nil;
        }

        NSMutableArray *list = [NSMutableArray array];

        for (CNLabeledValue *value in contact.phoneNumbers) {
            NSString *string = ((CNPhoneNumber *) value.value).stringValue;
            string = [string stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]];
            if ([string length] > 0) {
                [list addObject: string];
            }
        }

        return list;
    }
}

-(LuaTable *)toLuaTable{
    LuaTable *tb = [[LuaTable alloc] init];

    @synchronized (self.service) {
        NSError *err = nil;
        
        CNContact *contact = [self.service.store unifiedContactWithIdentifier: self.identifier
                                                                  keysToFetch: @[CNContactPhoneNumbersKey, CNContactGivenNameKey, CNContactFamilyNameKey, CNContactMiddleNameKey, CNContactNamePrefixKey, CNContactNameSuffixKey, CNContactNicknameKey, CNContactPhoneticGivenNameKey, CNContactPhoneticFamilyNameKey, CNContactPhoneticMiddleNameKey, CNContactOrganizationNameKey, CNContactJobTitleKey, CNContactDepartmentNameKey, CNContactEmailAddressesKey]
                                                                        error: &err];

        if (err) {
            NSLog(@"%@", err);
            return nil;
        }
        
        for (CNLabeledValue *value in contact.phoneNumbers) {
            NSString *string = ((CNPhoneNumber *) value.value).stringValue;
            string = [string stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]];
            if ([string length] > 0) {
                tb.map[@"phone"] = string;
                break;
            }
        }
        
        for (CNLabeledValue *value in contact.emailAddresses) {
            NSString *string = value.value;
            string = [string stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]];
            if ([string length] > 0) {
                tb.map[@"email"] = string;
                break;
            }
        }
        
        tb.map[@"firstName"] = contact.givenName ?: @"";
        tb.map[@"lastName"] = contact.familyName ?: @"";
        tb.map[@"middleName"] = contact.middleName ?: @"";
        tb.map[@"prefix"] = contact.namePrefix ?: @"";
        tb.map[@"suffix"] = contact.nameSuffix ?: @"";
        tb.map[@"nickname"] = contact.nickname ?: @"";
        tb.map[@"firstNamePhonetic"] = contact.phoneticGivenName ?: @"";
        tb.map[@"lastNamePhonetic"] = contact.phoneticFamilyName ?: @"";
        tb.map[@"middleNamePhonetic"] = contact.phoneticMiddleName ?: @"";
        tb.map[@"organization"] = contact.organizationName ?: @"";
        tb.map[@"jobTitle"] = contact.jobTitle ?: @"";
        tb.map[@"department"] = contact.departmentName ?: @"";
    }

    return tb;
}

@end
