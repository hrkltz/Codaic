//
//  ContentView.swift
//  Codaic
//
//  Created by Oliver Herklotz on 31.03.2025.
//

import SwiftUI
import Telegraph

struct ContentView: View {
    
    var server: Server?

    init() {
        guard let pythonPath = Bundle.main.path(forResource: "python/lib/python3.13", ofType: nil) else { return }
        guard let libDynloadPath = Bundle.main.path(forResource: "python/lib/python3.13/lib-dynload", ofType: nil) else { return }
        setenv("PYTHONPATH", [pythonPath, libDynloadPath].compactMap { $0 }.joined(separator: ":"), 1)
        
        Py_Initialize()
        PyRun_SimpleString("""
        print(\"3 * 5 =\", 3*5)
        print(\"Hello World!\")
        """)
        
        // Launch the HTTP server on Port 8080.
        server = Server()
        
        // Respond to all GET requests
        server?.route(.GET, "/") { request in
            return HTTPResponse(content: "Hello from Telegraph on iOS!")
        }
        
        do {
            try server?.start(port: 8080)
            print("Server started at http://localhost:8080")
        } catch {
            print("Failed to start server: \(error)")
        }
    }
    
    
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text(getWiFiIPAddress() ?? "Unknown")
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
