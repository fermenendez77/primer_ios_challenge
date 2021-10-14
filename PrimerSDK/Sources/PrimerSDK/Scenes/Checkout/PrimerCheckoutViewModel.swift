//
//  PrimerCheckoutViewModel.swift
//  
//
//  Created by Fernando Menendez on 11/10/2021.
//

import Foundation

public class PrimerCheckoutViewModel {
    
    //Dependencies
    var dataChecker : PrimerCheckoutDataChecker
    var paymentProcessor : PrimerCheckoutPaymentProcessor
    var storeService : PrimerStoreService
    
    weak var delegate : PrimerDelegate?
    var settings : PrimerSettings?
    
    var holderName : Binding<String> = Binding("")
    var cardNumber : Binding<String> = Binding("4111")
    var cvv : Binding<String> = Binding("")
    var expiryMonth : Binding<String> = Binding("")
    var expiryYear : Binding<String> = Binding("")

    var isValidHolderName = Binding(false)
    var isValidCardNumber = Binding(false)
    var isValidCVV = Binding(false)
    var isValidExpiryDate = Binding(false)
    var isFormValid = Binding(false)
    var isLoadingAccessToken = Binding(true)
    var state : Binding<CheckoutStates> = Binding(.ready)
    
    var buttonLabel : String {
        guard let settings = settings else {
            return ""
        }
        return "Pay \(settings.currency.rawValue) \(settings.amount)"
    }
    
    var token : String?
    let savedTokenKey : String = "primerSavedAccessToken"
    
    init(dataCheker : PrimerCheckoutDataChecker = PrimerCheckoutDataCheckerImp(),
         paymentProcessor : PrimerCheckoutPaymentProcessor = PrimerCheckoutPaymentProcessorImp(),
         storeService : PrimerStoreService = PrimerStoreServiceImp()) {
        self.dataChecker = dataCheker
        self.paymentProcessor = paymentProcessor
        self.storeService = storeService
        configureObservers()
    }
    
    private func configureObservers() {
        holderName.bind { [weak self] value in
            guard let self = self else {
                return
            }
            self.isValidHolderName.value = self.dataChecker.isHolderNameValid(value: value)
            self.checkIsFormIsValid()
        }
        cardNumber.bind { [weak self] value in
            guard let self = self else {
                return
            }
            self.isValidCardNumber.value = self.dataChecker.isNumberCardValid(value: value)
            self.checkIsFormIsValid()
        }
        cvv.bind { [weak self] value in
            guard let self = self else {
                return
            }
            self.isValidCVV.value = self.dataChecker.isCvvValid(value: value)
            self.checkIsFormIsValid()
        }
        expiryMonth.bind { [weak self] value in
            guard let self = self else {
                return
            }
            self.isValidExpiryDate.value = self.dataChecker.isExpiryDateValid(month: value,
                                                                        year: self.expiryYear.value)
            self.checkIsFormIsValid()
        }
        expiryYear.bind { [weak self] value in
            guard let self = self else {
                return
            }
            self.isValidExpiryDate.value = self.dataChecker
                .isExpiryDateValid(month: self.expiryMonth.value,year: value)
            self.checkIsFormIsValid()
        }
    }
    
    private func checkIsFormIsValid() {
        isFormValid.value = isValidHolderName.value &&
        isValidCardNumber.value &&
        isValidCVV.value &&
        isValidExpiryDate.value
    }
    
    public func viewWillAppear() {
        getAccessToken()
    }
    
    public func viewDidDisappear() {
        delegate?.onCheckoutDismissed()
    }
    
    // FIXME: Could be moved to another service
    private func getAccessToken() {
        isLoadingAccessToken.value = true
        let now = Date()
        if let savedToken = storeService.get(for: savedTokenKey, type: StoredToken.self),
           savedToken.expirationDate < now {
                self.token = savedToken.accessToken
                isLoadingAccessToken.value = false
        } else {
            delegate?.clientTokenCallback { [weak self] result in
                guard let self = self else {
                    return
                }
                self.isLoadingAccessToken.value = false
                switch result {
                case .success(let token):
                    let storedToken = StoredToken(accessToken: token.accessToken,
                                                  expirationDate: token.expirationDate)
                    self.storeService.save(storedToken, key: self.savedTokenKey)
                    self.token = token.accessToken
                case .failure(let error):
                    self.token = nil
                    self.storeService.remove(for: self.savedTokenKey)
                    self.delegate?.checkoutFailed(with: error)
                }
            }
        }
    }
    
    public func processPayment() {
        if let token = token, isFormValid.value {
            state.value = .processing
            let payload = PaymentPayload(number: cardNumber.value,
                                         cvv: cvv.value,
                                         expirationMonth: "11",
                                         expirationYear: "2024",
                                         cardholderName: holderName.value)
            
            paymentProcessor.process(paymentPayload: payload,
                                     accessToken: token) { [weak self] result in
                guard let self = self else {
                    return
                }
                switch result {
                case .success(let paymentMethod):
                    self.delegate?.onTokenizeSuccess(paymentMethod) { result in
                        switch result {
                        case .success(_):
                            self.state.value = .success
                        case .failure(_):
                            self.state.value = .error
                        }
                    }
                case .failure(let error):
                    self.state.value = .error
                    self.delegate?.checkoutFailed(with: error)
                }
            }
        }
    }
}

enum CheckoutStates {
    case success, error, ready, processing
}
