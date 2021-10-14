//
//  ViewModelTests.swift
//  
//
//  Created by Fernando Menendez on 13/10/2021.
//

import XCTest
@testable import PrimerSDK

final class ViewModelTests: XCTestCase {
    
    var defaultViewModel : PrimerCheckoutViewModel = {
        let viewModel = PrimerCheckoutViewModel()
        let settings = PrimerSettings(amount: 30.0, currency: .eur)
        viewModel.settings = settings
        return viewModel
    }()
    
    
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
    
    func testValidHolderName() {
        defaultViewModel.holderName.value = "J Doe"
        XCTAssertTrue(defaultViewModel.isValidHolderName.value)
    }
    
    func testIsValidCardNumber() {
        defaultViewModel.cardNumber.value = "4111111111111111"
        XCTAssertTrue(defaultViewModel.isValidCardNumber.value)
    }
    
    func testValidCVV() {
        defaultViewModel.cvv.value = "737"
        XCTAssertTrue(defaultViewModel.isValidCVV.value)
    }
    
    func testNonValidCVV() {
        defaultViewModel.cvv.value = "7A7"
        XCTAssertFalse(defaultViewModel.isValidCVV.value)
    }
    
    func testDateValid() {
        let viewModel = PrimerCheckoutViewModel(dataCheker : MockDataChecker())
        let settings = PrimerSettings(amount: 30.0,
                                      currency: .eur)
        viewModel.settings = settings
        viewModel.expiryYear.value = "2023"
        viewModel.expiryMonth.value = "11"
        XCTAssertTrue(viewModel.isValidExpiryDate.value)
    }
    
    func testFormIsValid() {
        let viewModel = PrimerCheckoutViewModel(dataCheker : MockDataChecker())
        let settings = PrimerSettings(amount: 30.0,
                                      currency: .eur)
        viewModel.settings = settings
        viewModel.expiryYear.value = "2023"
        viewModel.expiryMonth.value = "11"
        viewModel.cvv.value = "737"
        viewModel.holderName.value = "J Doe"
        viewModel.cardNumber.value = "4111111111111111"
        XCTAssertTrue(viewModel.isFormValid.value)
    }
    
    func testGetAccessTokenFlowSuccess() {
        let delegate = MockDelegateSuccess()
        defaultViewModel.delegate = delegate
        XCTAssertTrue(defaultViewModel.isLoadingAccessToken.value)
        defaultViewModel.viewWillAppear()
        
        XCTAssertNotNil(defaultViewModel.token)
        XCTAssertFalse(defaultViewModel.isLoadingAccessToken.value)
        XCTAssertTrue(defaultViewModel.token == delegate.token.accessToken)
    }
    
    func testGetAccessTokenFlowFail() {
        let delegate = MockDelegateError()
        defaultViewModel.delegate = delegate
        XCTAssertTrue(defaultViewModel.isLoadingAccessToken.value)
        defaultViewModel.viewWillAppear()
        XCTAssertNil(defaultViewModel.token)
    }
    
    func testPaymentFlowSuccess() {
        let successPaymentProcessor = MockPaymentProcessorSuccess()
        let viewModel = PrimerCheckoutViewModel(paymentProcessor : successPaymentProcessor)
        let delegate = MockDelegateSuccess()
        viewModel.delegate = delegate
        viewModel.expiryYear.value = "2023"
        viewModel.expiryMonth.value = "11"
        viewModel.cvv.value = "737"
        viewModel.holderName.value = "J Doe"
        viewModel.cardNumber.value = "4111111111111111"
        XCTAssertTrue(viewModel.isLoadingAccessToken.value)
        viewModel.viewWillAppear()
        XCTAssertTrue(viewModel.state.value == .ready)
        viewModel.processPayment()
        XCTAssertTrue(viewModel.state.value == .success)
    }
    
    func testPaymentFlowFail() {
        let failPaymentProcessor = MockPaymentProcessorFail()
        let viewModel = PrimerCheckoutViewModel(paymentProcessor : failPaymentProcessor)
        let delegate = MockDelegateSuccess()
        viewModel.delegate = delegate
        viewModel.expiryYear.value = "2023"
        viewModel.expiryMonth.value = "11"
        viewModel.cvv.value = "737"
        viewModel.holderName.value = "J Doe"
        viewModel.cardNumber.value = "4111111111111111"
        XCTAssertTrue(viewModel.isLoadingAccessToken.value)
        viewModel.viewWillAppear()
        XCTAssertTrue(viewModel.state.value == .ready)
        viewModel.processPayment()
        print("Status \(viewModel.state.value)")
        XCTAssertTrue(viewModel.state.value == .error)
    }
}

class MockDataChecker : PrimerCheckoutDataCheckerImp {
    
   
    override func isExpiryDateValid(month: String, year: String) -> Bool {
        guard let month = Int(month), let year = Int(year) else {
            return false
        }
        
        let calendar = Calendar(identifier: .gregorian)
        
        var nowComponents = DateComponents()
        nowComponents.year = 2021
        nowComponents.month = 10
        let nowDate = calendar.date(from: nowComponents)!
        
        var components = DateComponents()
        components.year = year
        components.month = month
        
        let sentDate = calendar.date(from: components)!
        
        return sentDate > nowDate
    }
}

class MockDelegateSuccess : PrimerDelegate {
    
    public let token = PrimerAccessToken(accessToken: "successToken", expirationDate: Date())

    
    func clientTokenCallback(_ completion: @escaping (Result<PrimerAccessToken, Error>) -> Void) {
        
        completion(.success(token))
    }
    
    func onTokenizeSuccess(_ paymentMethodToken: PaymentMethod, completion: (Result<Void, Error>) -> Void) {
        completion(.success(()))
    }
    
    func checkoutFailed(with error: Error) {

    }
    
    func onCheckoutDismissed() {
        
    }
    
    
}

class MockPaymentProcessorSuccess : PrimerCheckoutPaymentProcessor {
    
    func process(paymentPayload: PaymentPayload, accessToken: String, completionHandler: @escaping (Result<PaymentMethod, ErrorData>) -> Void) {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(dateFormetter)
        let paymentMethod = try! decoder.decode(PaymentMethod.self,
                                                from: mockPaymentMethod)
        completionHandler(.success(paymentMethod))
    }
    
}

class MockPaymentProcessorFail : PrimerCheckoutPaymentProcessor {
    
    func process(paymentPayload: PaymentPayload, accessToken: String, completionHandler: @escaping (Result<PaymentMethod, ErrorData>) -> Void) {
        completionHandler(.failure(.badFormatError))
    }
}

class MockDelegateError : PrimerDelegate {
    
    var successTokenCallback = false
    public let token = PrimerAccessToken(accessToken: "successToken", expirationDate: Date())

    
    func clientTokenCallback(_ completion: @escaping (Result<PrimerAccessToken, Error>) -> Void) {
        if successTokenCallback {
            completion(.success(token))
        } else {
            let error = NSError(domain: "error",
                                code: 100,
                                userInfo: [:])
            completion(.failure(error))
        }
    }
    
    func onTokenizeSuccess(_ paymentMethodToken: PaymentMethod, completion: (Result<Void, Error>) -> Void) {
        let error = NSError()
        completion(.failure(error))
    }
    
    func checkoutFailed(with error: Error) {
        
    }
    
    func onCheckoutDismissed() {
        
    }
}

