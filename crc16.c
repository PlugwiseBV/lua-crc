// CRC algorithm: arc
// width=16  poly=0x8005  init=0x0000  refin=true  refout=true  xorout=0x0000  check=0xbb3d  name="ARC"
// CRC algorithm: xmodem
// width=16  poly=0x1021  init=0x0000  refin=false  refout=false  xorout=0x0000  check=0x31c3  name="XMODEM"

#include <lua.h>
#include <lualib.h>
#include <lauxlib.h>
#include "crc16_arc.h"
#include "crc16_xmodem.h"

#define METATABLENAME "crc16_def_metatable"

struct crc16_functions {
    unsigned (*add)(unsigned, const char*);
    unsigned (*compute)(const char* data, size_t len);
};

enum crcType{
    ARC,
    XMODEM,
};

const char *const crc_types[] = {
    "ARC",
    "XMODEM",
    NULL
};

static int crc_new(lua_State *L)
{
    enum crcType tp = (enum crcType)luaL_checkoption(L, 1, NULL, crc_types);

    struct crc16_functions* funcs = lua_newuserdata(L, sizeof(struct crc16_functions));
    switch(tp){
        case ARC:
            funcs->add = crc16_arc_add;
            funcs->compute = crc16_arc_compute;
            break;
        case XMODEM:
            funcs->add = crc16_xmodem_add;
            funcs->compute = crc16_xmodem_compute;
            break;
    }
    luaL_getmetatable(L, METATABLENAME);
    lua_setmetatable(L, -2);
    return 1;
}

static int compute(lua_State *L)
{
    struct crc16_functions* funcs = (struct crc16_functions*)lua_touserdata(L, 1);
    const char *data;
    size_t len;
    data = luaL_checklstring(L, 2, &len);
    if (lua_isnumber(L, 3)) {
        int l = lua_tointeger(L, 3);
        if (l > 0 && l < (int) len)
            len = (size_t) l;
    }
    unsigned crc = funcs->compute(data, len);
    lua_pushinteger(L, crc);
    return 1;
}

static int add(lua_State *L){
    struct crc16_functions* funcs = (struct crc16_functions*)lua_touserdata(L, 1);
    const char* byte;
    unsigned crc = (unsigned short)lua_tonumber(L, 2);
    byte = luaL_checklstring(L, 3, NULL);
    crc = funcs->add(crc, byte);
    lua_pushinteger(L, crc);
    return 1;
}

static luaL_reg crc16_methods[] =
{
    { "new",        crc_new },
    { NULL, NULL }
};

static luaL_reg crc16_metamethods [] =
{
    {"compute",     compute },
    {"add",         add     },
    {NULL,          NULL    }
};

int luaopen_crc16(lua_State* L)
{
    /* this function and luaL_register are removed on Lua 5.2 */
    luaL_newmetatable(L, METATABLENAME);
    lua_pushstring(L, "__index");
    lua_pushvalue(L, -2);
    lua_settable(L, -3);
    luaL_openlib(L, NULL, crc16_metamethods, 0);
    luaL_openlib(L, "crc16", crc16_methods, 0);
    return 1;
}
