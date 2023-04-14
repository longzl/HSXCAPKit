#import <CAPKit/SecurityM.h>

/**Manifest model*/
@interface ManifestM : NSObject

@property (nonatomic, strong) NSString *appId;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *version;
@property (nonatomic, strong) NSString *token;
@property (nonatomic, strong) NSMutableArray *tags;
@property (nonatomic, strong) NSString *desc;
@property (nonatomic, strong) NSString *vendor;
@property (nonatomic, strong) SecurityM *security;
@property (nonatomic, strong) NSMutableArray *devices;
@property (nonatomic, strong) NSMutableArray *libraries;
@property (nonatomic, strong) NSMutableArray *metadata;
@property (nonatomic, strong) NSMutableArray *scripts;
@property (nonatomic, strong) NSMutableDictionary *events;
@property (nonatomic, strong) NSString *index;
@property (nonatomic, strong) NSString *category;
@property (nonatomic, strong) NSObject *parameters;
@property (nonatomic, strong) NSString *loadModel;

+ (ManifestM *) manifestWithDictionary: (NSDictionary *) dic;

@end
