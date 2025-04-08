//
//  ContentView.swift
//  Codaic
//
//  Created by Oliver Herklotz on 31.03.2025.
//

import SwiftUI
import Telegraph
import os

struct ContentView: View {
    @State private var ipAddress: String
    
    
    init() {
        self.ipAddress = iOSUtil.getWifiIpAddress() ?? "Unknown"
        CodaicServer.start()
    }
    
    
    var body: some View {
        NavigationStack {
            VStack() {
                Form {
                    Section() {
                        LabelValueActionComponent(label: "WLAN-IP", value: self.ipAddress, actionIconLabel: "arrow.clockwise") {
                            self.ipAddress = iOSUtil.getWifiIpAddress() ?? "Unbekannt"
                        }
                    }
                    
                    Section("Anleitung") {
                        HStack(alignment: .top) {
                            Text("1.")
                            Text("Verbinde dein iPhone mit dem selben WLAN wie dein Desktop oder Laptop.")
                        }
                        HStack(alignment: .top) {
                            Text("2.")
                            Text("Falls im Feld \"WLAN-IP\" noch \"Unbekannt\" angezeigt wird, drücke den aktualisierung Button.")
                        }
                        HStack(alignment: .top) {
                            Text("3.")
                            Text("Um die Codaic IDE zu öffnen, gebe die oben angezeigte \"WLAN-IP\" in deinen Browser auf deinem Desktop oder Laptop ein.")
                        }
                        HStack(alignment: .top) {
                            Text("4.")
                            Text("Drücke auf den grünen Start-Button um dein Project auszuführen.")
                        }
                    }
                }
                RunButtonComponent(destination: ExecutionView())
                Spacer()
                // Footer
                Text("App-Version \(iOSUtil.getAppVersion() ?? "?.?") – Build \(iOSUtil.getBuildNumber() ?? "?")")
                    .font(.footnote)
                    .foregroundColor(.secondary)
            }
            .background(Color(UIColor.systemGroupedBackground))
            .navigationTitle("Codaic")
        }
    }
}

#Preview {
    ContentView()
}
