//
//  ClientToken.swift
//  
//
//  Created by Fernando Menendez on 12/10/2021.
//

import Foundation

struct ClientToken: Codable {
    
    let clientToken : String
    let expirationDate: Date
}
