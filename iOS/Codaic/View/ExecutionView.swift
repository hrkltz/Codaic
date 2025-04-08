
//
//  ContentView.swift
//  Codaic
//
//  Created by Oliver Herklotz on 31.03.2025.
//

import SwiftUI
struct ExecutionView: View {
    @State private var codaicRuntime: CodaicRuntime = CodaicRuntime()
    @ObservedObject private var logManager = LogManager.shared
    
    var body: some View {
        LogComponent(logEntryArray: logManager.logEntryArray)
        .onAppear {
            codaicRuntime.start()
            logManager.addLog("Start")
        }
        .onDisappear {
            logManager.addLog("Stop")
            codaicRuntime.stop()
        }
    }
}

#Preview {
    ExecutionView()
}
