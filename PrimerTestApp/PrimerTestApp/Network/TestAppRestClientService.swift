//
//  TestAppRestClientService.swift
//  PrimerTestApp
//
//  Created by Fernando Menendez on 13/10/2021.
//

import Foundation

class RestClientService {
    
    var urlBase: String
    var urlSession: URLSession = URLSession(configuration: .default)
    
    init(urlBase : String) {
        self.urlBase = urlBase
    }
    
    func dataRequest<T> (endpoint: String,
                         method : RequestMethod = .get,
                         queryItems: [URLQueryItem]? = nil,
                         headerParams : [(String, String)]? = nil,
                         body : String? = nil,
                         returnType: T.Type,
                         decoder : JSONDecoder = JSONDecoder(),
                         completionHandler: @escaping (Result<T,ErrorData>) -> Void) where T : Decodable {
        //Configure url
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = self.urlBase
        urlComponents.path = endpoint
        if let query = queryItems {
            urlComponents.queryItems = query
        }
        let url = urlComponents.url!
        
        //Configure Request
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        if let headers = headerParams {
            headers.forEach { field, value in
                request.setValue(value, forHTTPHeaderField: field)
            }
        }
        
        if let body = body,
           let data = body.data(using: .utf8)  {
            request.httpBody = data
        }
        
        
        let dataTask = urlSession.dataTask(with: request) { data, response, error in
            guard let response = response as? HTTPURLResponse,
                  response.statusCode == 200,
                  let data = data else {
                      DispatchQueue.main.async {
                          completionHandler(.failure(.networkingError))
                      }
                      return
                  }
            do {
                let result = try decoder.decode(T.self, from: data)
                DispatchQueue.main.async {
                    completionHandler(.success(result))
                }
            } catch(let error) {
                print(error)
                DispatchQueue.main.async {
                    completionHandler(.failure(.badFormatError))
                }
            }
            
        }
        dataTask.resume()
    }
    
}

enum ErrorData : Error {
    
    case networkingError
    case badRequestError
    case badFormatError
}

enum RequestMethod : String {
    
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}
