//
//  ProjectEndpoint.swift
//  Codaic
//
//  Created by Oliver Herklotz on 04.04.2025.
//

import Foundation
import Telegraph

struct ProjectEndpoint {
    static public func registerRoutes(_ server: Server) {
        server.route(.POST, "/project", handlePost)
        server.route(.GET, "/project", handleGet)
    }
    
    
    /// curl -X POST http://<IP>:8080/project -H "Content-Type: text/plain" --data-binary "@project.json"
    static public func handlePost(request: HTTPRequest) -> HTTPResponse {
        LoggerUtil.logError("[API][/project][POST]")
        // 1. Check if the body is not empty.
        let bodyString = String(data: request.body, encoding: .utf8) ?? ""
        
        guard !bodyString.isEmpty else {
            LoggerUtil.logError("Empty body.")
            return HTTPResponse(.badRequest, content: "Empty body.")
        }
        
        // 2. Check if the bodyString is a valid ProjectModel.
        guard let project: ProjectModel = JsonUtil.decode(bodyString) else {
            LoggerUtil.logError("JsonUtil.decode(..) failed.")
            return HTTPResponse(.badRequest, content: "Invalid body.")
        }
        
        // 3. Serialize the ProjectModel again to safely store it.
        guard let projectJson = JsonUtil.encode(project) else {
            LoggerUtil.logError("JsonUtil.encode(..) failed.")
            return HTTPResponse(.internalServerError, content: "Failed to serialize project.")
        }
        
        // 4. Save the ProjectModel to the storage.
        guard FileUtil.save(fileName: "project.json", content: projectJson) else {
            LoggerUtil.logError("FileUtil.save(..) failed.")
            return HTTPResponse(.internalServerError, content: "Failed to save project.")
        }
        
        return HTTPResponse(.noContent)
    }

    
    /// curl -X GET http://<IP>:8080/project
    static public func handleGet(request: HTTPRequest) -> HTTPResponse {
        LoggerUtil.logError("[API][/project][GET]")
        // 1. Load the project from the storage.
        guard let projectJson = FileUtil.load(fileName: "project.json") else {
            LoggerUtil.logError("FileUtil.load(..) failed.")
            return HTTPResponse(.internalServerError, content: "Failed to load project.")
        }
        
        // 2. Deserialize the projectJson into an ProjectModel to be sure it's valid.
        guard let _: ProjectModel = JsonUtil.decode(projectJson) else {
            LoggerUtil.logError("JsonUtil.decode(..) failed.")
            return HTTPResponse(.internalServerError, content: "Failed to decode project.")
        }
        
        return HTTPResponse(.ok, content: projectJson)
    }
}
