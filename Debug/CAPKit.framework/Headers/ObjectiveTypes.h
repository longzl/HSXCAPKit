/*
 *
 * LuaObjCBridge.h
 *
 * By Tom McClean, 2005/2006
 * tom@pixelballistics.com
 *
 * This file is public domain. It is provided without any warranty whatsoever,
 * and may be modified or used without attribution.
 *
 */
#define LUA_OBJC_TYPE_BITFIELD 'b'
#define LUA_OBJC_TYPE_C99_BOOL 'B'
#define LUA_OBJC_TYPE_CHAR 'c'
#define LUA_OBJC_TYPE_UNSIGNED_CHAR 'C'
#define LUA_OBJC_TYPE_DOUBLE 'd'
#define LUA_OBJC_TYPE_FLOAT 'f'
#define LUA_OBJC_TYPE_INT 'i'
#define LUA_OBJC_TYPE_UNSIGNED_INT 'I'
#define LUA_OBJC_TYPE_LONG 'l'
#define LUA_OBJC_TYPE_UNSIGNED_LONG 'L'
#define LUA_OBJC_TYPE_LONG_LONG 'q'
#define LUA_OBJC_TYPE_UNSIGNED_LONG_LONG 'Q'
#define LUA_OBJC_TYPE_SHORT 's'
#define LUA_OBJC_TYPE_UNSIGNED_SHORT 'S'
#define LUA_OBJC_TYPE_VOID 'v'
#define LUA_OBJC_TYPE_UNKNOWN '?'

#define LUA_OBJC_TYPE_ID '@'
#define LUA_OBJC_TYPE_CLASS '#'
#define LUA_OBJC_TYPE_POINTER '^'
#define LUA_OBJC_TYPE_STRING '*'

#define LUA_OBJC_TYPE_UNION '('
#define LUA_OBJC_TYPE_UNION_END ')'
#define LUA_OBJC_TYPE_ARRAY '['
#define LUA_OBJC_TYPE_ARRAY_END ']'
#define LUA_OBJC_TYPE_STRUCT '{'
#define LUA_OBJC_TYPE_STRUCT_END '}'
#define LUA_OBJC_TYPE_SELECTOR ':'

#define LUA_OBJC_TYPE_IN 'n'
#define LUA_OBJC_TYPE_INOUT 'N'
#define LUA_OBJC_TYPE_OUT 'o'
#define LUA_OBJC_TYPE_BYCOPY 'O'
#define LUA_OBJC_TYPE_CONST 'r'
#define LUA_OBJC_TYPE_BYREF 'R'
#define LUA_OBJC_TYPE_ONEWAY 'V'

#define LUA_OBJC_ID "__objc_id"
#define LUA_OBJC_TABLE_R "__objc_id_table_r"
#define LUA_OBJC_TABLE_RW "__objc_id_table_rw"

#define LUA_OBJC_KEY "__id__"

#define MAX_METHOD_NAME_LEN 256

#define USE_CHAR_1_0_AS_BOOLEAN

#define setArgumentValue(type,buff, value) (*((type*)buff))=((type)value)
