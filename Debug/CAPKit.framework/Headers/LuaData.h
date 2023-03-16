@interface LuaData : AbstractLuaTableCompatible

@property (nonatomic, readonly) NSData *data;
@property (nonatomic, readonly) NSString *info;

- (instancetype) initWithData: (NSData *) data withInfo: (NSString *) info;

@end
