//
//  iOSUtil.swift
//  Codaic
//
//  Created by Oliver Herklotz on 06.04.2025.
//

import Foundation

class iOSUtil {
    static public func getWifiIpAddress() -> String? {
        var ipAddress: String?
        var ifAddress: UnsafeMutablePointer<ifaddrs>? = nil
        
        if getifaddrs(&ifAddress) == 0 {
            var ptr = ifAddress
            
            while ptr != nil {
                guard let interface = ptr?.pointee else {
                    break
                }

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
                        ipAddress = String(cString: hostname)
                        break
                    }
                }
                
                ptr = ptr?.pointee.ifa_next
            }
            
            freeifaddrs(ifAddress)
        }

        return ipAddress
    }
    
    
    static public func getAppVersion() -> String? {
        return Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
    }
    
    
    static public func getBuildNumber() -> String? {
        return Bundle.main.infoDictionary?["CFBundleVersion"] as? String
    }
}
