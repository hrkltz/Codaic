//
//  RootEndpoint.swift
//  Codaic
//
//  Created by Oliver Herklotz on 10.04.2025.
//

import Foundation
import Telegraph

struct RootEndpoint {
    static public func registerRoutes(_ server: Server) {
        server.route(.GET, "/", handleGet)
    }

    
    static public func handleGet(request: HTTPRequest) -> HTTPResponse {
        LoggerUtil.logInfo("[API][/][GET]")
        
        guard let htmlPath = Bundle.main.path(forResource: "index", ofType: "html"),
              let htmlPage = try? String(contentsOfFile: htmlPath, encoding: .utf8) else {
            return HTTPResponse(.notFound, content: "404 - Not found")
        }

        
        return HTTPResponse(.ok, content: htmlPage)
    }
}

