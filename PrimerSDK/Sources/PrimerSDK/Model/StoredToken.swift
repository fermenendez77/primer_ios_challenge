//
//  StoredToken.swift
//  
//
//  Created by Fernando Menendez on 12/10/2021.
//

import Foundation

struct StoredToken : Codable {
    
    let accessToken : String
    let expirationDate : Date
}
