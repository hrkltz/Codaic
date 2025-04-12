
//
//  ContentView.swift
//  Codaic
//
//  Created by Oliver Herklotz on 31.03.2025.
//

import SwiftUI

struct RuntimeView: View {
    @State private var codaicRuntime: CodaicRuntime = CodaicRuntime()
    @ObservedObject private var logManager = LogRuntime.shared
    
    var body: some View {
        LogComponent(logEntryArray: logManager.logEntryArray)
        .onAppear {
            codaicRuntime.start()
        }
        .onDisappear {
            codaicRuntime.stop()
        }
    }
}

#Preview {
    RuntimeView()
}
