int lua_objc_open(lua_State* L);
id lua_objc_getid(lua_State* L,int stack_index);
void lua_objc_pushid(lua_State* L,id object);
int lua_objc_isid(lua_State* L,int stack_index);

void lua_objc_pushpropertylist(lua_State* L,id propertylist);
id lua_objc_topropertylist(lua_State* L,int stack_index);

int lua_objc_methodcall(lua_State* L);
int lua_objc_tostringcall(lua_State* L);
int lua_objc_methodlookup(lua_State* L);
int lua_objc_tostring(lua_State* L);
int lua_objc_fieldset(lua_State* L);

int lua_objc_block_function(lua_State *L);

void LuaError(lua_State *L, int errfunc);
