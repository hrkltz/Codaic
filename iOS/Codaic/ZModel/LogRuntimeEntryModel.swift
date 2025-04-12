//
//  LogRuntimeEntryModel.swift
//  Codaic
//
//  Created by Oliver Herklotz on 12.04.2025.
//

import Foundation

struct LogRuntimeEntryModel: Identifiable {
    let id = UUID()
    let timestamp: String
    let message: String
}
