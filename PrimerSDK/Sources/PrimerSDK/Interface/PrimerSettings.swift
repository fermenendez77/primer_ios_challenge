//
//  PrimerSettings.swift
//  
//
//  Created by Fernando Menendez on 13/10/2021.
//

import Foundation

public struct PrimerSettings {
    
    public let amount : Double
    public let currency : Currency
    
    public init(amount : Double, currency : Currency) {
        self.amount = amount
        self.currency = currency
    }
}

public enum Currency : String {
    
    case usd = "$"
    case eur = "€"
    case gbp = "£"
}
