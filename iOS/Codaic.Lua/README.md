# Codaic / iOS / Codaic.Lua

## Add Lua To iOS App

1. Download the source ([Lua 5.4.7](https://www.lua.org/ftp/lua-5.4.7.tar.gz))
2. Extract the src folder into Support/Lua-5.4.7
3. Remove the following files as we want to limit the access a bit:
  1. loslib.c (OS functions)
  2. loadlib.c (package)
  3. liolib.c (IO functions)
  4. luac.c & lua.c (Interpreter)
4. Remove the corresponding links from `linit.c`
  1. `{LUA_LOADLIBNAME, luaopen_package},`
  2. `{LUA_IOLIBNAME, luaopen_io},`
  3. `{LUA_OSLIBNAME, luaopen_os},`
4. Put the following content into Bridging-Header.h
```h
#ifndef Bridging_Header_h
#define Bridging_Header_h

#include "lua.h"
#include "lauxlib.h"
#include "lualib.h"

#endif
```
5. Lua is using Macros as stack‑shuffling helpers (`lua_pop(L,n)`, `lua_insert(L,idx)` & `lua_remove(L,idx)`) which can't be called from Swift
  1. Comment them out (`lua.h`)
  2. Implement them in c functions 

## WebServer

[readium/GCDWebServer](https://github.com/readium/GCDWebServer) | 10.12.2024 | 12
[Telegraph](https://github.com/Building42/Telegraph) | 01.04.2024 | 820
[yene/GCDWebServer](https://github.com/yene/GCDWebServer) | 26.12.2023 | 34
[Embassy](https://github.com/envoy/Embassy) | 30.01.2023 | 604
[swifter](https://github.com/httpswift/swifter) | 26.09.2020 | 3900
[GCDWebServer](https://github.com/swisspol/GCDWebServer) | 15.03.2020 | 6500
[Ambassador](https://github.com/envoy/Ambassador) | 11.10.2018 | 187

In case of rejection other solutions:
- Let the phone connect as a client to a remote server which host the UI
- Use TCP or Bluetooth as a connection

Note: Codea Air Code (VS Code Extension) + Codea is technical doing exactly the same.