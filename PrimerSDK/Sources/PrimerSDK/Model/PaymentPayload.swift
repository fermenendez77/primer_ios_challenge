//
//  PaymentInstrument.swift
//  
//
//  Created by Fernando Menendez on 12/10/2021.
//

import Foundation

struct PaymentInstrumentRequest: Codable {
    let paymentInstrument: PaymentPayload
}

struct PaymentPayload: Codable {
    let number, cvv, expirationMonth, expirationYear: String
    let cardholderName: String
}
