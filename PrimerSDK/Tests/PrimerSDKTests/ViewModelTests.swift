//
//  ViewModelTests.swift
//  
//
//  Created by Fernando Menendez on 13/10/2021.
//

import XCTest
@testable import PrimerSDK

final class ViewModelTests: XCTestCase {
    
    
    func testButtonLabelUSD() {
        let viewModel = PrimerCheckoutViewModel()
        let settings = PrimerSettings(amount: 20.0, currency: .usd)
        viewModel.settings = settings
        XCTAssertTrue(viewModel.buttonLabel == "Pay $ 20.0")
    }
    
    func testButtonLabelEur() {
        let viewModel = PrimerCheckoutViewModel()
        let settings = PrimerSettings(amount: 30.0, currency: .eur)
        viewModel.settings = settings
        XCTAssertTrue(viewModel.buttonLabel == "Pay € 30.0")
    }
    
    
}
