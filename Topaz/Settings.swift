//
//  Settings.swift
//  Topaz
//
//  Created by Timmy Nguyen on 6/24/24.
//

import Foundation

struct Settings {
    static var shared = Settings()
    
    private func archiveJSON<T: Encodable>(value: T, key: String) {
        let data = try! JSONEncoder().encode(value)
        let string = String(data: data, encoding: .utf8)
        UserDefaults.standard.set(string, forKey: key)
    }
    
    private func unarchiveJSON<T: Decodable>(key: String) -> T? {
        guard let string = UserDefaults.standard.string(forKey: key),
              let data = string.data(using: .utf8) else {
            return nil
        }
        
        return try! JSONDecoder().decode(T.self, from: data)
    }
    
    var stores: [Store] {
        get {
            return unarchiveJSON(key: "stores") ?? []
        }
        set {
            archiveJSON(value: newValue, key: "stores")
        }
    }
}
