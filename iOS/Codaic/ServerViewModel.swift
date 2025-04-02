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
    private var server: Server?

    
    private func startServer() {
        server = Server()
        
        // Respond to all GET requests
        server?.route(.GET, "/") { request in
            return HTTPResponse(content: "Hello from Telegraph on iOS!")
        }
        
        do {
            try server?.start(port: 8080)
            print("Server started at http://localhost:8080")
        } catch {
            print("Failed to start server: \(error)")
        }
    }

    
    private func stopServer() {
        server?.stop()
        print("🛑 Server stopped")
    }
}
