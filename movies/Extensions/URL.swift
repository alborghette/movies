//
//  Extensions.swift
//  movies
//
//  Created by Murilo Alves Alborghette on 8/18/19.
//  Copyright © 2019 Alborghette. All rights reserved.
//

import Foundation

extension URL {
    
    init(urlString string: String, with parameters: [String: Any]? = nil) {
        
        guard var urlComponent = URLComponents.init(string: string) else {
            fatalError(String(format: "URL %@ is not valid", string))
        }
        if let params = parameters {
            var queryItemArray = [URLQueryItem]()
            
            for (key, value) in params {
                queryItemArray.append(URLQueryItem(name: key, value: "\(value)"))
            }
            urlComponent.queryItems = queryItemArray
        }
        
        guard let url = urlComponent.url else {
            fatalError(String(format: "URL %@ conversion is not valid", string))
        }
        
        self = url
    }
    
}
