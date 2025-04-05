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
    @StateObject private var serverViewModel = ServerViewModel()

    
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text(getWiFiIPAddress() ?? "Unknown")
            Toggle(isOn: $serverViewModel.isOn) {
                Text("Start Web Server")
                    .font(.headline)
            }
            PlayStopButton()
        }
        .padding()
    }
    
    
    func getWiFiIPAddress() -> String? {
        var address: String?

        var ifaddr: UnsafeMutablePointer<ifaddrs>? = nil
        if getifaddrs(&ifaddr) == 0 {
            var ptr = ifaddr
            while ptr != nil {
                guard let interface = ptr?.pointee else { break }

                let addrFamily = interface.ifa_addr.pointee.sa_family
                if addrFamily == UInt8(AF_INET) { // IPv4 only
                    let name = String(cString: interface.ifa_name)
                    if name == "en0" { // Wi-Fi
                        var addr = interface.ifa_addr.pointee
                        var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
                        getnameinfo(&addr,
                                    socklen_t(interface.ifa_addr.pointee.sa_len),
                                    &hostname,
                                    socklen_t(hostname.count),
                                    nil,
                                    socklen_t(0),
                                    NI_NUMERICHOST)
                        address = String(cString: hostname)
                        break
                    }
                }
                ptr = ptr?.pointee.ifa_next
            }
            freeifaddrs(ifaddr)
        }

        return address
    }
}

#Preview {
    ContentView()
}
