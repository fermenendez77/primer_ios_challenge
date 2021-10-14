//
//  File.swift
//  
//
//  Created by Fernando Menendez on 14/10/2021.
//

import Foundation

let mockPaymentMethod = """
    {
       "deleted":false,
       "createdAt":"2021-05-04T09:33:52.293855",
       "updatedAt":"2021-05-04T09:33:52.293855",
       "deletedAt":null,
       "token":"alooYT5lS4m2JdL60rNo9nwxNjIwMTIwODMy",
       "analyticsId":"-NxZbWYcXPiRMynOCdzu2G5L",
       "tokenType":"SINGLE_USE",
       "paymentInstrumentType":"PAYMENT_CARD",
       "paymentInstrumentData":{
          "last4Digits":"1111",
          "expirationMonth":"03",
          "expirationYear":"2030",
          "cardholderName":"J Doe",
          "network":"Visa",
          "isNetworkTokenized":false,
          "binData":{
             "network":"VISA",
             "issuerCountryCode":"US",
             "issuerName":"JPMORGAN CHASE BANK, N.A.",
             "issuerCurrencyCode":null,
             "regionalRestriction":"UNKNOWN",
             "accountNumberType":"UNKNOWN",
             "accountFundingType":"UNKNOWN",
             "prepaidReloadableIndicator":"NOT_APPLICABLE",
             "productUsageType":"UNKNOWN",
             "productCode":"VISA",
             "productName":"VISA"
          }
       },
       "vaultData":null,
       "threeDSecureAuthentication":null
    }
""".data(using: .utf8)!

