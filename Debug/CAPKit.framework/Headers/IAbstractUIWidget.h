@class CAPLuaImage;

@protocol IAbstractUIWidget <NSObject>

- (void) _LUA_setAlpha: (NSNumber *) value;

- (float) getAlpha;

- (void) reload;

- (void) reset;

- (void) mark;

- (NSDictionary *) getModel;

- (NSString *) getXml;

- (void) suspendLayout;

- (void) resumeLayout;

- (CAPLuaImage *) _COROUTINE_getSnapshot;

- (CAPLuaImage *) _COROUTINE_getContentSnapshot;

- (PackedArray *) getRect;

@end
