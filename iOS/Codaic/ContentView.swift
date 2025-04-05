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

    
    init() {
        // Initialize Python.
        guard let pythonPath = Bundle.main.path(forResource: "python/lib/python3.13", ofType: nil) else { return }
        guard let libDynloadPath = Bundle.main.path(forResource: "python/lib/python3.13/lib-dynload", ofType: nil) else { return }
        setenv("PYTHONPATH", [pythonPath, libDynloadPath].compactMap { $0 }.joined(separator: ":"), 1)
        
        Py_Initialize()
        
        // Just for testing.
        let code = """
        print(\"3 * 5 =\", 3*5)
        print(\"Hello World!\")
        """
        
        let project1 = ProjectModel(input: "", code: code, output: "")
        
        guard let project1Json = JsonUtil.encode(project1) else {
            LoggerUtil.logError("JsonUtil.encode(..) failed.")
            return
        }
        
        guard FileUtil.save(fileName: "project.json", content: project1Json) else {
            LoggerUtil.logError("FileUtil.save(..) failed.")
            return
        }
        
        guard let project2Json = FileUtil.load(fileName: "project.json") else {
            LoggerUtil.logError("FileUtil.load(..) failed.")
            return
        }
        
        guard let project2: ProjectModel = JsonUtil.decode(project2Json) else {
            LoggerUtil.logError("JsonUtil.decode(..) failed.")
            return
        }
        
        PyRun_SimpleString(project2.code)
    }
    
    
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
