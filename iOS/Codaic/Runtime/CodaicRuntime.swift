//
//  CodaicRuntime.swift
//  Codaic
//
//  Created by Oliver Herklotz on 05.04.2025.
//

import Foundation

class CodaicRuntime {
    init() {
        guard let pythonPath = Bundle.main.path(forResource: "python/lib/python3.13", ofType: nil) else {
            LoggerUtil.logError("python/lib/python3.13 missing.")
            return
        }
        
        guard let libDynloadPath = Bundle.main.path(forResource: "python/lib/python3.13/lib-dynload", ofType: nil) else {
            LoggerUtil.logError("python/lib/python3.13/lib-dynload missing.")
            return
        }
        
        setenv("PYTHONPATH", [pythonPath, libDynloadPath].compactMap { $0 }.joined(separator: ":"), 1)
    }
    
    
    public func start() {
        guard let projectJson = FileUtil.load(fileName: "project.json") else {
            LoggerUtil.logError("FileUtil.load(..) failed.")
            return
        }
        
        guard let project: ProjectModel = JsonUtil.decode(projectJson) else {
            LoggerUtil.logError("JsonUtil.decode(..) failed.")
            return
        }
        
        // Create a fresh execution context.
        Py_Initialize()
        let globals = PyDict_New()
        let locals = PyDict_New()

        // Optionally: fill with built-ins so functions like print work
        let builtins = PyEval_GetBuiltins()
        PyDict_SetItemString(globals, "__builtins__", builtins)
        
        LogRuntime.shared.addMessage("Start")
        
        // Note:
        // 1. Arg is the script
        // 2. Arg Py_eval_input   == A single expression (like 2 + 2, x * 5). It returns a value.
        //        Py_single_input == A single interactive statement (like print("Hello")). Like REPL behavior.
        //        Py_file_input   == A full Python script (multiple lines, functions, etc.). Use this for scripts.
        // 3. Arg globals == The Python global symbol table (variables, functions, etc.).
        // 4. Arg locals == The local symbol table (used inside functions, etc.).
        let run_result = PyRun_String(project.code, Py_file_input, globals, locals)
        
        if (run_result != nil) {
            // Get the variable 'result' from locals
            let result = PyDict_GetItemString(locals, "result");
            
            if (result != nil) {
                let resultStr = PyObject_Str(result);
                let resultCStr = PyUnicode_AsUTF8(resultStr);
                let resultString = String(cString: resultCStr!)
                // TODO: All returns should be JSON objects
                //       Log: { "Message": "..." }
                //       Torch: { "Level": 0.0 .. 1.0 }
                
                switch project.output {
                case "Log":
                    Log.input(resultString)
                    break
                case "Torch":
                    Torch.input(resultString)
                    break
                default:
                    LoggerUtil.logError("Unexcpected output. (\(project.output))")
                }
                
                // Clean-up
                Py_DECREF(resultStr);
                // No DECREF for result — it's a borrowed ref from the dictionary
            } else {
                LoggerUtil.logError("'result' variable not found.")
            }
        } else {
            // Print the Python error if any
            PyErr_Print();
        }
        
        // Clean-up
        Py_DECREF(run_result);
        Py_DECREF(globals);
        Py_DECREF(locals);
        Py_Finalize();
    }
    
    
    public func stop() {
        // TODO
    }
}
