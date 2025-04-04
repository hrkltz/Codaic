//
//  ServerViewModel.swift
//  Codaic
//
//  Created by Oliver Herklotz on 02.04.2025.
//

import Foundation
import Telegraph

@MainActor
class ServerViewModel: ObservableObject {
    @Published var isServerOn = false {
        didSet {
            print("Server is now \(isServerOn ? "on" : "off")")
            if isServerOn {
                startServer()
            } else {
                stopServer()
            }
        }
    }
    private var server: Server = Server()

    
    private func startServer() {
        server = Server()
        
        // Respond to all GET requests
        server.route(.GET, "/") { request in
            return HTTPResponse(content: "Codaic server is running!")
        }
        
        ProjectEndpoint.registerRoutes(server)
        
        guard (try? server.start(port: 8080)) != nil else {
            LoggerUtil.logError("server.start(..) failed.")
            return
        }
    }

    
    private func stopServer() {
        server.stop()
    }
}
