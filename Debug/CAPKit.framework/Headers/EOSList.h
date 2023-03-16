@interface EOSList : NSObject <EOSListInterface>{
    NSMutableArray *list;
}

@property (nonatomic, weak) NSObject *parent;

- (id) initWithArray: (NSArray *) array;

@end
