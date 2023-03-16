#define MAX_PROTOCOL_COUNT 5

@interface LuaObjectProxy : NSProxy{
    id object;
    Protocol *protocols[MAX_PROTOCOL_COUNT];
    int protocolCount;
}

@property (nonatomic, strong) id object;

- (id) initWithObject: (id) obj withProtocols: (Protocol *) col, ...;
- (id) initWithObject: (id) obj withProtocolVAList: (va_list) cols;
- (id) initWithObject: (id) obj withProtocol: (Protocol *) col;

- (BOOL) addProtocol: (Protocol *) col;

@end
