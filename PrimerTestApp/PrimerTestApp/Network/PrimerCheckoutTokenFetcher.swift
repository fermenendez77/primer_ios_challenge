//
//  PrimerCheckoutDataFetcher.swift
//  
//
//  Created by Fernando Menendez on 12/10/2021.
//

import Foundation
import PrimerSDK

protocol PrimerCheckoutTokenFetcher {
    
    func getToken(completionHandler : @escaping (Result<(String,Date),ErrorData>) -> Void)
}

class PrimerCheckoutTokenFetcherImp : PrimerCheckoutTokenFetcher {
    
    let service = RestClientService(urlBase: baseURL)
    
    func getToken(completionHandler: @escaping (Result<(String,Date), ErrorData>) -> Void) {
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(dateFormetter)
        
        let headers = [
            ("Content-Type", "application/json"),
            ("X-Api-Key", apiKey)
        ]
        
        service.dataRequest(endpoint: "/auth/client-token",
                            method: .post,
                            headerParams: headers,
                            returnType: ClientToken.self,
                            decoder: decoder) { result in
            
            switch result {
            case .success(let cToken):
                let jwt = decode(jwtToken: cToken.clientToken)
                if let accessToken = jwt["accessToken"] as? String {
                    let result = (accessToken, cToken.expirationDate)
                    completionHandler(.success(result))
                } else {
                    completionHandler(.failure(.badRequestError))
                }
                
            case .failure(let error):
                completionHandler(.failure(error))
            }
        }
    }
}

