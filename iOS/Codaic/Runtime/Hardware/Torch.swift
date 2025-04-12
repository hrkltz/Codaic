//
//  Torch.swift
//  Codaic
//
//  Created by Oliver Herklotz on 12.04.2025.
//

import AVFoundation

class Torch {
    private struct Input: Codable {
        public let level: Float
    }
    
    
    static private func on(level: Float) {
        guard let device = AVCaptureDevice.default(for: .video), device.hasTorch else {
            LoggerUtil.logError("Torch unavailable.")
            return
        }
        
        guard device.isTorchModeSupported(.on) else {
            LoggerUtil.logError("Torch mode not supported.")
            return;
        }
        
        guard (try? device.lockForConfiguration()) != nil else {
            LoggerUtil.logError("Torch could not be locked.")
            return
        }
        
        guard (try? device.setTorchModeOn(level: level)) != nil else {
            LoggerUtil.logError("device.setTorchModeOn(..) failed.")
            return
        }
        
        device.unlockForConfiguration()
    }
    
    
    static private func off() {
        guard let device = AVCaptureDevice.default(for: .video), device.hasTorch else {
            LoggerUtil.logError("Torch unavailable.")
            return
        }
        
        guard device.isTorchModeSupported(.off) else {
            LoggerUtil.logError("Torch mode not supported.")
            return;
        }
        
        guard (try? device.lockForConfiguration()) != nil else {
            LoggerUtil.logError("Torch could not be locked.")
            return
        }
        
        device.torchMode = .off
        device.unlockForConfiguration()
    }
    
    
    static public func input(_ inputJson: String) {
        guard let input: Input = JsonUtil.decode(inputJson) else {
            LoggerUtil.logError("JsonUtil.decode(..) failed.")
            return
        }
        
        if (input.level > 0.0) {
            on(level: input.level)
        } else {
            off()
        }
    }
}
