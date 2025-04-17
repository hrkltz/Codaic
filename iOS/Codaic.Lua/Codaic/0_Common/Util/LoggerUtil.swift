//
//  LoggerUtil.swift
//  Codaic
//
//  Created by Oliver Herklotz on 04.04.2025.
//

import Foundation
import os

struct LoggerUtil {
    static private let logger = Logger(
        subsystem: Bundle.main.bundleIdentifier ?? "io.hrkltz.codaic",
        category: "General"
    )

    
    static public func logError(_ message: String) {
        logger.error("\(message, privacy: .public)")
    }
    
    
    static public func logInfo(_ message: String) {
        logger.info("\(message, privacy: .public)")
    }
}
