//
//  JsonUtil.swift
//  Codaic
//
//  Created by Oliver Herklotz on 05.04.2025.
//

import Foundation

struct JsonUtil {
    /// Decode a JSON string into a Decodable object
    static public func decode<T: Decodable>(_ stringJson: String) -> T? {
        guard let data = stringJson.data(using: .utf8) else {
            LoggerUtil.logError("json.data(..) failed.")
            return nil
        }
        
        let result: T
        
        do {
            result = try JSONDecoder().decode(T.self, from: data)
        } catch {
            LoggerUtil.logError("JSONDecoder().decode(..) failed. (\(error.localizedDescription))")
            return nil
        }
        
        return result
    }
    

    /// Encode an Encodable object into a JSON string
    static public func encode<T: Encodable>(_ object: T) -> String? {
        let resultJson: Data
        
        do {
            resultJson = try JSONEncoder().encode(object)
        } catch {
            LoggerUtil.logError("JSONEncoder().encode(..) failed. (\(error.localizedDescription))")
            return nil
        }
        
        return String(data: resultJson, encoding: .utf8)
    }
}
