@interface PackedArray : NSObject

@property (nonatomic, readonly) NSArray *array;

- (id) initWithArray: (NSArray *) value;
@end
