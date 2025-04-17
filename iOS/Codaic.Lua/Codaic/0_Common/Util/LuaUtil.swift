//
//  LuaRunner.swift
//  Codaic
//
//  Created by Oliver Herklotz on 17.04.2025.
//

import Foundation

enum LuaUtil {
    /// Helper: pop last Lua error off the stack and show it.
    static private func dumpError() {
        // lua_tostring needs the state; ask the C side for it or expose another helper.
        print("Lua error – check runlua.c for details")
    }
    
    
    /// Runs a literal Lua snippet such as `"print('hi')"`
    static public func run(code: String) {
        let rc = code.withCString(run_lua_string)
        
        if (rc != 0) {
            dumpError()
        }
    }
    

    /// Runs `myfile.lua` that you’ve added to the main bundle.
    static public func run(file name: String) {
        guard let path = Bundle.main.path(forResource: name, ofType: "lua") else {
            print("Lua file \(name) not found")
            
            return
        }
        
        let rc = path.withCString(run_lua_file)
        
        if (rc != 0) {
            dumpError()
        }
    }
}
