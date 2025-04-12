//
//  Log.swift
//  Codaic
//
//  Created by Oliver Herklotz on 12.04.2025.
//

class Log {
    static public func input(_ inputJson: String) {
        RuntimeLog.shared.addMessage(inputJson)
    }
}
