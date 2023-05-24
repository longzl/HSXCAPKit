@interface SecurityM : NSObject

@property (nonatomic, strong) NSString *login;
@property (nonatomic, readonly) NSMutableArray *roles;

@end
