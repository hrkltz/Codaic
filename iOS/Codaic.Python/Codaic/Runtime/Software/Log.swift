//
//  Log.swift
//  Codaic
//
//  Created by Oliver Herklotz on 12.04.2025.
//

class Log {
    private struct Input: Codable {
        public let message: String
    }
    
    
    static public func input(_ inputJson: String) {
        guard let input: Input = JsonUtil.decode(inputJson) else {
            LoggerUtil.logError("JsonUtil.decode(..) failed.")
            return
        }
        
        LogRuntime.shared.addMessage(input.message)
    }
}

