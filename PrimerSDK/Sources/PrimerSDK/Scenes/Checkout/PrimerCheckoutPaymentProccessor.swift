//
//  PrimerCheckoutPaymentProccessor.swift
//  
//
//  Created by Fernando Menendez on 12/10/2021.
//

import Foundation

protocol PrimerCheckoutPaymentProcessor {
    
    func process(paymentPayload : PaymentPayload,
                 accessToken : String,
                 completionHandler: @escaping (Result<PaymentMethod, ErrorData>) -> Void)
}

class PrimerCheckoutPaymentProcessorImp : PrimerCheckoutPaymentProcessor{
    
    let service = RestClientService(urlBase: paymentBaseURL)
    
    func process(paymentPayload : PaymentPayload,
                 accessToken : String,
                 completionHandler: @escaping (Result<PaymentMethod, ErrorData>) -> Void) {
        
        let paymentRequest = PaymentInstrumentRequest(paymentInstrument: paymentPayload)
        guard let data = try? JSONEncoder().encode(paymentRequest),
              let body = String(data: data, encoding: .utf8) else {
                  completionHandler(.failure(.badFormatError))
                  return
        }
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(dateFormetter)
        
        let headers = [
            ("Content-Type", "application/json"),
            ("Primer-Client-Token", accessToken)
        ]
        
        service.dataRequest(endpoint: "/payment-instruments",
                            method: .post,
                            headerParams: headers,
                            body: body,
                            returnType: PaymentMethod.self,
                            decoder: decoder) { result in
            switch result {
                
            case .success(let payment):
                completionHandler(.success(payment))
            case .failure(let error):
                print(error)
                completionHandler(.failure(error))
            }
        }
    }
}
