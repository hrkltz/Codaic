//
//  CodaicRuntime.swift
//  Codaic
//
//  Created by Oliver Herklotz on 05.04.2025.
//

import Foundation

class CodaicRuntime {
    init() {
        // Initialize Python.
        guard let pythonPath = Bundle.main.path(forResource: "python/lib/python3.13", ofType: nil) else { return }
        guard let libDynloadPath = Bundle.main.path(forResource: "python/lib/python3.13/lib-dynload", ofType: nil) else { return }
        setenv("PYTHONPATH", [pythonPath, libDynloadPath].compactMap { $0 }.joined(separator: ":"), 1)
        
        Py_Initialize()
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
        
        PyRun_SimpleString(project.code)
    }
    
    
    public func stop() {
        // TODO
    }
}
