//
//  PrimerAccessToken.swift
//  
//
//  Created by Fernando Menendez on 13/10/2021.
//

import Foundation

public struct PrimerAccessToken {
    
    public let accessToken : String
    public let expirationDate : Date
    
    public init(accessToken : String, expirationDate : Date) {
        self.accessToken = accessToken
        self.expirationDate = expirationDate
    }
}
