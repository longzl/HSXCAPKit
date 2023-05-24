@interface EOSMap : NSObject <EOSMapInterface>{
    NSMutableDictionary *dataMap;
}

#ifdef DEBUG_EOS
@property (nonatomic, weak) NSObject *parent;
#endif

@end
