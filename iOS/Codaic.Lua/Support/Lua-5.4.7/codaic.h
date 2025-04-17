//
//  codaic.h
//  Codaic
//
//  Created by Oliver Herklotz on 17.04.2025.
//

#ifndef codaic_h
#define codaic_h

/// Run a Lua string. Returns 0 on success, non‑zero on Lua error.
int run_lua_string(const char *utf8Script);

/// Run a .lua file sitting at `fullPath`. Same return‑code contract.
int run_lua_file  (const char *fullPath);

#endif
