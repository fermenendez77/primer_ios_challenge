//
//  ViewController.swift
//  PrimerTestApp
//
//  Created by Fernando Menendez on 04/10/2021.
//

import UIKit
import PrimerSDK

class ViewController: UIViewController {
    
    var tokenFetcher : PrimerCheckoutTokenFetcher?

    override func viewDidLoad() {
        super.viewDidLoad()
        tokenFetcher = PrimerCheckoutTokenFetcherImp()
        Primer.shared.delegate = self
    }
    
    
    @IBAction func defaultPressentationButtonPressed(_ sender: Any) {
        Primer.shared.settings = PrimerSettings(amount: 20.0, currency: .eur)
        Primer.shared.showCheckout(on: self)
    }
    
    
    @IBAction func customPresentationButtonPressed(_ sender: Any) {
        Primer.shared.settings = PrimerSettings(amount: 50.0, currency: .usd)
        // Configure Theme
        let colorTheme = PrimerColorTheme(background: UIColor(named: "backgroundCheckout")!,
                                          label: UIColor(named: "labelsCheckout")!,
                                          loadingTintColor: .systemBlue)
        let theme = PrimerTheme(cornerRadiusTheme: PrimerCornerRadiusTheme(sheet: 8.0,
                                                                           buttons: 12.0,
                                                                           textfields: 10.0),
                                paymentButtonColor: UIColor(named: "buttonCheckout")!,
                                colorTheme: colorTheme)
        // Set the Theme to PrimerSDK
        Primer.shared.theme = theme
        Primer.shared.showCheckout(on: self)
    }

}

extension ViewController : PrimerDelegate {
   
    
    func onTokenizeSuccess(_ paymentMethodToken: PaymentMethod,
                           completion: (Result<Void,Error>) -> Void) {
        print(paymentMethodToken)
        // MARK: Mocked call
        createPament(with: paymentMethodToken) { result in
            switch result {
            case .success():
                completion(.success(()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    
    func clientTokenCallback(_ completion: @escaping (Result<PrimerAccessToken,Error>) -> Void) {
        // MARK: This should be an API Call to your Backend for getting the accessToken
        tokenFetcher?.getToken { result in
            switch result {
            case .success(let response):
                let accessToken = PrimerAccessToken(accessToken: response.0,
                                                    expirationDate: response.1)
                completion(.success(accessToken))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func checkoutFailed(with error: Error) {
        print(error)
    }
    
    func onCheckoutDismissed() {
        print("Checkout Dismissed!")
    }
    
}

// MARK: Mocking the call to our Backend
extension ViewController {
    
    func createPament(with method : PaymentMethod, completion : (Result<Void,Error>) -> Void) {
        let result = true
        if result {
            completion(.success(()))
        } else {
            let error = NSError()
            completion(.failure(error))
        }
    }
}
