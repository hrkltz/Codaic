//
//  LogEntryModel.swift
//  Codaic
//
//  Created by Oliver Herklotz on 08.04.2025.
//

import Foundation

struct LogEntryModel: Identifiable {
    let id = UUID()
    let timestamp: String
    let message: String
}
