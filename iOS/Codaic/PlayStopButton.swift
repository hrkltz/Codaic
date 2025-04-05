//
//  PlayStopButton.swift
//  Codaic
//
//  Created by Oliver Herklotz on 05.04.2025.
//

import SwiftUI

struct PlayStopButton: View {
    @State private var isPlaying = false
    @State private var codaicRuntime: CodaicRuntime = CodaicRuntime()

    
    var body: some View {
        Button(action: {
            isPlaying.toggle()
            if isPlaying {
                startAction()
            } else {
                stopAction()
            }
        }) {
            HStack {
                Image(systemName: isPlaying ? "stop.fill" : "play.fill")
                Text(isPlaying ? "Stop" : "Play")
            }
            .padding()
            .foregroundColor(.white)
            .background(isPlaying ? Color.red : Color.green)
            .cornerRadius(10)
        }
    }

    
    func startAction() {
        codaicRuntime = CodaicRuntime()
        codaicRuntime.start()
    }

    
    func stopAction() {
        codaicRuntime.stop()
    }
}
