//
//  ProjectModel.swift
//  Codaic
//
//  Created by Oliver Herklotz on 04.04.2025.
//

import Foundation

class ProjectModel: Codable {
    var input: String
    var code: String
    var output: String
    
    
    init(input: String, code: String, output: String) {
        self.input = input
        self.code = code
        self.output = output
    }
}
