//
//  RuntimeLogEntryModel.swift
//  Codaic
//
//  Created by Oliver Herklotz on 12.04.2025.
//

import Foundation

struct RuntimeLogEntryModel: Identifiable {
    let id = UUID()
    let timestamp: String
    let message: String
}
