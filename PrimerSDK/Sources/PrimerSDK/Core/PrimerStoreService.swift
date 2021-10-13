//
//  PrimerStoreService.swift
//  
//
//  Created by Fernando Menendez on 12/10/2021.
//

import Foundation

protocol PrimerStoreService {
    
    func save<T>(_ object : T, key : String) where T : Codable
    func get<T>(for key : String, type : T.Type) -> T? where T : Codable
    func remove(for key: String)
}

class PrimerStoreServiceImp : PrimerStoreService {
    
    // We should use Keychain for storing sensitive data like the accessToken
    
    func save<T>(_ object: T, key: String) where T : Codable {
        
        guard let data = try? JSONEncoder().encode(object) else {
            return
        }
        UserDefaults.standard.set(data, forKey: key)
    }
    
    func get<T>(for key: String, type : T.Type) -> T? where T : Codable {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(dateFormetter)
        guard let data = UserDefaults.standard.object(forKey: key) as? Data,
              let object = try? decoder.decode(T.self, from: data) else {
                  return nil
        }
        return object
    }

    func remove(for key: String) {
        UserDefaults.standard.removeObject(forKey: key)
    }
}
