@protocol IViewWidget <IAbstractUIWidget>
- (CAPAbstractUIWidget *) addChildJSON: (NSString *) jsonString DEPRECATED_ATTRIBUTE;

- (CAPAbstractUIWidget *) addChildJSON: (NSString *) jsonString at: (int) idx DEPRECATED_ATTRIBUTE;

/**Add `Widget` in this View
 
 Lua Samples:
 
 local w = container:addChild{qName="textfield", id="password", height=44, backgroundAlpha=1, backgroundColor="#FF00FF"}
 w:setText("xxxxx")
 -- or
 w.text = "xxxx"
 
 @param t the input json string with `Widget` definition
 @return the new created `Widget`
 */
- (CAPAbstractUIWidget *) addChild: (id) t;

- (CAPAbstractUIWidget *) addChild: (id) t at: (int) idx DEPRECATED_ATTRIBUTE;
- (CAPAbstractUIWidget *) addChild: (id) t : (int) idx;

- (void) _LUA_removeChildById: (NSObject *) wid DEPRECATED_ATTRIBUTE;
- (void) _LUA_removeChild: (NSObject *) wid;
- (void) _LUA_removeChild: (NSObject *) wid : (NSNumber *) destroy;

- (void) _LUA_removeChildAt: (int) idx;

- (int) _LUA_indexChildById: (NSObject *) wid DEPRECATED_ATTRIBUTE;
- (int) _LUA_indexChild: (NSObject *) wid;

- (void) _LUA_removeAllChildren;

- (void) _LUA_reLayoutChildren;

- (NSArray *) listChildren;
@end
