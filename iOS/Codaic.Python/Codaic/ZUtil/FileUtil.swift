//
//  JsonFile.swift
//  Codaic
//
//  Created by Oliver Herklotz on 04.04.2025.
//

import Foundation

class FileUtil {
    /// Returns the URL for the JSON file in the app's internal Documents directory
    static private func fileURL(_ fileName: String) -> URL? {
        let manager = FileManager.default
        guard let docs = manager.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return nil
        }
        
        return docs.appendingPathComponent(fileName).appendingPathExtension("json")
    }
    

    /// Saves a Codable object as JSON to internal storage
    static public func save(fileName: String, content: String) -> Bool {
        guard let url = fileURL(fileName) else {
            LoggerUtil.logError("fileURL(..) failed.")
            return false
        }
        
        guard (try? content.write(to: url, atomically: true, encoding: .utf8)) != nil else {
            LoggerUtil.logError("content.write(..) failed.")
            return false
        }
        
        return true
    }

    
    /// Loads a Codable object from JSON file in internal storage
    static public func load(fileName: String) -> String? {
        guard let url = fileURL(fileName) else {
            LoggerUtil.logError("fileURL(..) failed.")
            return nil
        }
        
        guard let content = try? String(contentsOf: url, encoding: .utf8) else {
            LoggerUtil.logError("String(..) failed.")
            return nil
        }
        
        return content
    }
}
