//
//  Network.swift
//  movies
//
//  Created by Murilo Alves Alborghette on 8/18/19.
//  Copyright © 2019 Alborghette. All rights reserved.
//

import Foundation
import Reachability

enum NetworkResponse {
    case success(Data)
    case failure(NetworkError)
}

enum NetworkError: Error {
    case other(Error)
    case connectionFail
}

protocol NetworkProtocol {
    typealias NetworkCompletion = (NetworkResponse) -> Void
    typealias NetworkQueryParams = [String: Any]
    
    func get(resource: String, params: NetworkQueryParams, completion: @escaping NetworkCompletion)
}

class Network: NetworkProtocol {
    
    private var baseUrl: String
    private var apiConfiguration: NetworkQueryParams
    
    private let session = URLSession(configuration: .default)
    
    init(withBaseUrl baseUrl: String, andAPIConfiguration apiConfiguration: NetworkQueryParams) {
        self.baseUrl = baseUrl
        self.apiConfiguration = apiConfiguration
    }
    
    func get(resource: String, params: NetworkQueryParams, completion: @escaping NetworkCompletion) {
        
        let stringUrl = baseUrl + resource
        let queryParameters = params.merging(apiConfiguration) { (current, _) in current }
        
        let url = URL(urlString: stringUrl, with: queryParameters)
        
        let request = URLRequest(url: url)
        
        self.doTask(with: request, completion: completion)
    }
    
    private func doTask(with request: URLRequest, completion: @escaping NetworkCompletion) {
        var request = request
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        if let reachability = Reachability(), reachability.connection == .none {
            DispatchQueue.main.async {
                completion(.failure(.connectionFail))
            }
        } else {
            
            let task = session.dataTask(with: request) { (data, response, error) in
                
                DispatchQueue.main.async {
                
                    if let error = error {
                        completion(.failure(.other(error)))
                    } else {
                        guard let httpResponse = response as? HTTPURLResponse else {
                            completion(.failure(.other(NSError(domain: "Couldn't get HTTP response", code: 0, userInfo: nil))))
                            return
                        }
                        
                        if (200 ..< 300 ~= httpResponse.statusCode) {
                            if let data = data {
                                completion(.success(data))
                            } else {
                                completion(.failure(.other(NSError(domain: "Couldn't get HTTP Response Data cause is nil", code: 0, userInfo: nil))))
                            }
                        } else {
                            completion(.failure(.other(NSError(domain: "Bad Status", code: 0, userInfo: nil))))
                        }
                    }
                }
            }
            
            task.resume()
        }
    }
    
}
