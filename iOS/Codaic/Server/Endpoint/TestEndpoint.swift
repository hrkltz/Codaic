
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
        let project: ProjectModel = ProjectModel(input: "", code: "print(\"Hello A!\")", output: "Log")
        let projectJson: String = JsonUtil.encode(project)!
        _ = FileUtil.save(fileName: "project.json", content: projectJson)
        return HTTPResponse(.ok, content: projectJson)
    }
    
    
    /// curl -X GET http://<IP>:8080/test/b
    static public func handleBGet(request: HTTPRequest) -> HTTPResponse {
        LoggerUtil.logInfo("[API][/test/b][GET]")
        let project: ProjectModel = ProjectModel(input: "", code: """
        import json
        import random

        x = round(random.uniform(0.0, 1.0), 1)
        y = 3.2
        z = x+y
        
        result = json.dumps({
            \"message\": f\"{x} + {y} = {z}\"
        })
        """, output: "Log")
        let projectJson: String = JsonUtil.encode(project)!
        _ = FileUtil.save(fileName: "project.json", content: projectJson)
        return HTTPResponse(.ok, content: projectJson)
    }
    
    
    /// curl -X GET http://<IP>:8080/test/c
    static public func handleCGet(request: HTTPRequest) -> HTTPResponse {
        LoggerUtil.logInfo("[API][/test/c][GET]")
        let project: ProjectModel = ProjectModel(input: "", code: """
        import json
        import random

        level = round(random.uniform(0.0, 1.0), 2)
        
        result = json.dumps({
            \"level\": level
        })
        """, output: "Torch")
        let projectJson: String = JsonUtil.encode(project)!
        _ = FileUtil.save(fileName: "project.json", content: projectJson)
        return HTTPResponse(.ok, content: projectJson)
    }
}
