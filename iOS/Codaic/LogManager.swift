//
//  LogManager.swift
//  Codaic
//
//  Created by Oliver Herklotz on 08.04.2025.
//

import SwiftUI
import Combine

final class LogManager: ObservableObject {
    static let shared = LogManager()
    @Published private(set) var logEntryArray: [LogEntryModel] = []
    private let queue = DispatchQueue(label: "log.queue", attributes: .concurrent)

    
    private init() {
        // Empty.
    }

    
    func addLog(_ message: String) {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss.SSS"
        let timestamp = formatter.string(from: Date())
        let logEntry: LogEntryModel = LogEntryModel(timestamp: timestamp, message: message)

        queue.async(flags: .barrier) {
            DispatchQueue.main.async {
                self.logEntryArray.append(logEntry)
            }
        }
    }

    
    func clear() {
        queue.async(flags: .barrier) {
            DispatchQueue.main.async {
                self.logEntryArray.removeAll()
            }
        }
    }
}
