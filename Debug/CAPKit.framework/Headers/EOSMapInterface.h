@class EOSMap, EOSList;

@protocol EOSMapInterface <LuaTableCompatible>
/**get or create a new map with the key
 
 do replace only if the original value is not a map
 
 Lua Samples:
 
 local newmap = map:getMap("newkey")
 
 @param key key
 @return map
 */
- (EOSMap *) getMap: (NSString *) key;

/**get or create a new list with the key
 
 do replace only if the original value is not a list
 
 Lua Samples:
 
 local newlist = map:getList("newkey")
 
 @param key key
 @return list
 */
- (EOSList *) getList: (NSString *) key;

/**replace values with the key in the map
 
 Lua Samples:
 
 local oldvalue = map:put_value("newkey", "newvalue")
 
 @param key key
 @param value value to replace
 */
- (void) put: (NSString *) key value: (NSObject *) value;

- (void) put: (NSString *) key : (NSObject *) value;

/**remove value by key
 
 Lua Samples:
 
 local removed = map:remove("key")
 
 @param key key to remove
 */
- (void) remove: (NSString *) key;

/**get value in the map
 
 Lua Samples:
 
 local value = map:get("key")
 
 @param key key
 @return the value in the map, nil if not found
 */
- (NSObject *) get: (NSString *) key;

/**remove all objects in the map
 
 Lua Samples:
 
 map:clear()
 */
- (void) clear;

/**list all keys in the map
 
 Lua Samples:
 
 map:keys()
 
 @return all keys
 */
- (EOSList *) keys;

/**list all values in the map
 
 Lua Samples:
 
 map:values()
 
 @return all values
 */
- (EOSList *) values;

/**convert the collection as json string
 
 object that not compatible with json will be ignored.
 
 Lua Samples:
 
 map:tostring()
 
 @return json result
 */
- (NSString *) tostring;

/**convert the collection to lua value
 
 Lua Samples:
 
 local maptable = map:tolua()
 
 @return lua compatible dictionary
 */
- (NSDictionary *) tolua DEPRECATED_ATTRIBUTE;

- (NSDictionary *) totable;

@end
