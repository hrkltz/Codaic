//
//  codaic.c
//  Codaic
//
//  Created by Oliver Herklotz on 17.04.2025.
//

#include "codaic.h"
#include "lauxlib.h"
#include "lualib.h"

/// lua_newstate / lua_close instead.
static lua_State *L = NULL;


static void ensure_state(void) {
    if (!L) {
        // Initiate a new state.
        L = luaL_newstate();
        
        // Load math, string, table, …
        luaL_openlibs(L);
    }
}


int run_lua_string(const char *code) {
    ensure_state();
    
    return luaL_dostring(L, code);
}


int run_lua_file(const char *path) {
    ensure_state();
    
    return luaL_dofile(L, path);
}


/* If you need Lua’s output inside the UI (rather than the console), register your own C function as print:
static int swift_print(lua_State *L) {
    const char *msg = lua_tostring(L, 1);
    // forward to NSLog, combine into a Swift closure via function pointer, etc.
    return 0;
}

lua_pushcfunction(L, swift_print);
lua_setglobal(L, "print");
 */
