//
//  Server.swift
//  Codaic
//
//  Created by Oliver Herklotz on 05.04.2025.
//

import Telegraph

class CodaicServer {
    static private let server: Server = Server()
    static private let port: Int = 8080
    static private(set) var isRunning: Bool = false
    private static let setup: Void = {
        // Register /project endpoints.
        ProjectEndpoint.registerRoutes(CodaicServer.server)
        TestEndpoint.registerRoutes(CodaicServer.server)
    }()
    
    
    static public func start() {
        // Note: There is no static init function in Swift. The approach of using a static setup variable has the same effect. It will be only executed once.
        _ = setup
        
        // Check if the server is not already runnning.
        guard (!isRunning) else {
            LoggerUtil.logError("Server is already running.")
            return
        }
        
        guard ((try? server.start(port: port)) != nil) else {
            LoggerUtil.logError("server.start(..) failed.")
            return
        }
        
        isRunning = true
    }
    
    
    static public func stop() {
        guard (isRunning) else {
            LoggerUtil.logError("Server is already stopped.")
            return
        }
        
        server.stop()
        
        isRunning = false
    }
    
    
    /*init () {
        LoggerUtil.logError("When is init() called???")
        // Respond to all other GET requests.
        CodaicServer.server.route(.GET, "/") { request in
            LoggerUtil.logError("[API][/]")
            return HTTPResponse(content: "Codaic server is running!")
        }
            
        // Register /project endpoints.
        ProjectEndpoint.registerRoutes(CodaicServer.server)
    }*/
}
