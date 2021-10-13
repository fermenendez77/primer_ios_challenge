//
//  File.swift
//  
//
//  Created by Fernando Menendez on 12/10/2021.
//

import Foundation

// MARK: - Payment
public struct PaymentMethod: Codable {
    
    let deleted: Bool?
    let createdAt, updatedAt: Date?
    let deletedAt: Date?
    let token, analyticsID, tokenType, paymentInstrumentType: String
    let paymentInstrumentData: PaymentInstrumentData

    enum CodingKeys: String, CodingKey {
        case deleted, createdAt, updatedAt, deletedAt, token
        case analyticsID = "analyticsId"
        case tokenType, paymentInstrumentType, paymentInstrumentData
    }
}

// MARK: - PaymentInstrumentData
public struct PaymentInstrumentData: Codable {
    let last4Digits, expirationMonth, expirationYear, cardholderName: String
    let network: String
    let isNetworkTokenized: Bool
    let binData: BinData
}

// MARK: - BinData
public struct BinData: Codable {
    let network, issuerCountryCode, issuerName: String
    let issuerCurrencyCode: String?
    let regionalRestriction, accountNumberType, accountFundingType, prepaidReloadableIndicator: String
    let productUsageType, productCode, productName: String
}
