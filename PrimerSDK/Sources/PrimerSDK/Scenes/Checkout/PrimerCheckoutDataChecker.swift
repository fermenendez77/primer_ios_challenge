//
//  PrimerCheckoutDataChecker.swift
//  
//
//  Created by Fernando Menendez on 11/10/2021.
//

import Foundation

protocol PrimerCheckoutDataChecker {
    
    var nameLenght : Int { get set }
    var cvvLenght : Int { get set }
    var cardNumberLenght : Int { get set }
    var cardNumberGroup : Int { get set }
    
    func isNumberCardValid(value : String) -> Bool
    func isHolderNameValid(value : String) -> Bool
    func isCvvValid(value : String) -> Bool
    func isExpiryDateValid(month : String, year : String) -> Bool
}


class PrimerCheckoutDataCheckerImp : PrimerCheckoutDataChecker {
    
    var nameLenght: Int = 3
    var cvvLenght: Int = 3
    var cardNumberLenght: Int = 16
    var cardNumberGroup: Int = 4
    var minYear: Int = Calendar.current.component(.year, from: Date())
    
    func isNumberCardValid(value: String) -> Bool {
        value.count >= cardNumberLenght
    }
    
    func isHolderNameValid(value: String) -> Bool {
        value.count >= nameLenght
    }
    
    func isCvvValid(value: String) -> Bool {
        return Int(value) != nil && value.count <= cvvLenght
    }
        
    func isExpiryDateValid(month : String, year : String) -> Bool {
        guard let month = Int(month), let year = Int(year) else {
            return false
        }
        let now = Date()
        var dateComponents = DateComponents()
        let calendar = Calendar.current
        dateComponents.month = month
        dateComponents.year = year
        if let expirationDate = calendar.date(from: dateComponents) {
            return expirationDate > now
        } else {
            return false
        }
    }
}
