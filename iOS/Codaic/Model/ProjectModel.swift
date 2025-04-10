//
//  Model.swift
//  Codaic
//
//  Created by Oliver Herklotz on 04.04.2025.
//

import Foundation

class ProjectModel: Codable {
    var input: String
    var code: String
    
    
    init(input: String, code: String) {
        self.input = input
        self.code = code
    }
}
