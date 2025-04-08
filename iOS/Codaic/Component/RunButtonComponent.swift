//
//  PlayStopButton.swift
//  Codaic
//
//  Created by Oliver Herklotz on 05.04.2025.
//

import SwiftUI

struct RunButtonComponent<Destination: View>: View {
    let destination: Destination
    
    
    var body: some View {
        NavigationLink(destination: destination) {
            
                HStack {
                    Image(systemName: "play.fill")
                    Text("Ausführen")
                }
                .padding()
                .foregroundColor(.white)
                .background(Color.green)
                .cornerRadius(10)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    RunButtonComponent(destination: ExecutionView())
}
