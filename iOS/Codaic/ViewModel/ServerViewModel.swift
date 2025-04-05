//
//  ServerViewModel.swift
//  Codaic
//
//  Created by Oliver Herklotz on 02.04.2025.
//

import Foundation

@MainActor
class ServerViewModel: ObservableObject {
    // Note: isOn just represent the status of the toggle switch.
    @Published var isOn = CodaicServer.isRunning {
        didSet {
            if isOn {
                CodaicServer.start()
            } else {
                CodaicServer.stop()
            }
        }
    }
}
