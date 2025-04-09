
//
//  ProjectEndpoint.swift
//  Codaic
//
//  Created by Oliver Herklotz on 04.04.2025.
//

import Foundation
import Telegraph

struct TestEndpoint {
    static public func registerRoutes(_ server: Server) {
        server.route(.GET, "/test/a", handleAGet)
        server.route(.GET, "/test/b", handleBGet)
        server.route(.GET, "/test/c", handleCGet)
    }
    
    
    /// curl -X GET http://<IP>:8080/test/a
    static public func handleAGet(request: HTTPRequest) -> HTTPResponse {
        LoggerUtil.logInfo("[API][/test/a][GET]")
        let project: ProjectModel = ProjectModel(input: "", code: "print(\"Hello A!\")", output: "")
        let projectJson: String = JsonUtil.encode(project)!
        _ = FileUtil.save(fileName: "project.json", content: projectJson)
        return HTTPResponse(.ok, content: projectJson)
    }
    
    
    /// curl -X GET http://<IP>:8080/test/b
    static public func handleBGet(request: HTTPRequest) -> HTTPResponse {
        LoggerUtil.logInfo("[API][/test/b][GET]")
        let project: ProjectModel = ProjectModel(input: "", code: "print(\"Hello B!\")", output: "")
        let projectJson: String = JsonUtil.encode(project)!
        _ = FileUtil.save(fileName: "project.json", content: projectJson)
        return HTTPResponse(.ok, content: projectJson)
    }
    
    
    /// curl -X GET http://<IP>:8080/test/c
    static public func handleCGet(request: HTTPRequest) -> HTTPResponse {
        LoggerUtil.logInfo("[API][/test/c][GET]")
        let project: ProjectModel = ProjectModel(input: "", code: """
        x = 5
        y = 3
        result = x + y
        """, output: "")
        let projectJson: String = JsonUtil.encode(project)!
        _ = FileUtil.save(fileName: "project.json", content: projectJson)
        return HTTPResponse(.ok, content: projectJson)
    }
}
