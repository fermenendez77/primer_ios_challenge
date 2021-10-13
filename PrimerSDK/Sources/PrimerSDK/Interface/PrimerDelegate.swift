//
//  PrimerDelegate.swift
//  
//
//  Created by Fernando Menendez on 04/10/2021.
//

import Foundation

public protocol PrimerDelegate : AnyObject {
    
    /*
     * This callback is called when is required get a new accessToken from your backend. You
       
     */
    func clientTokenCallback(_ completion: @escaping (Result<PrimerAccessToken,Error>) -> Void)
    
    
    func onTokenizeSuccess(_ paymentMethodToken: PaymentMethod,
                           completion: (Result<Void,Error>) -> Void)
    
    func checkoutFailed(with error: Error)
    func onCheckoutDismissed()
}
