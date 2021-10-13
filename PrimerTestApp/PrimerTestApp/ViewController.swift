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
        Primer.shared.settings = PrimerSettings(amount: 20.0, currency: .eur)
        configureView()
    }
    
    func configureView() {
        let button = UIButton(frame: CGRect(x: 0, y: 0,
                                            width: 100, height: 100))
        button.setTitle("Present SDK", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        button.backgroundColor = .yellow
        button.isUserInteractionEnabled = true
        button.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(button)
        button.centerXAnchor.constraint(equalTo: view.centerXAnchor)
            .isActive = true
        button.centerYAnchor.constraint(equalTo: view.centerYAnchor)
            .isActive = true
        button.addTarget(self,
                         action: #selector(presentSDKButtonPressed),
                         for: .touchUpInside)
    }
    
    @objc func presentSDKButtonPressed() {
        Primer.shared.showCheckout(on: self)
    }
}

extension ViewController : PrimerDelegate {
   
    
    func onTokenizeSuccess(_ paymentMethodToken: PaymentMethod,
                           completion: (Result<Void,Error>) -> Void) {
        print(paymentMethodToken)
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
