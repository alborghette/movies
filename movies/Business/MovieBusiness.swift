//
//  MovieBusiness.swift
//  movies
//
//  Created by Murilo Alves Alborghette on 8/18/19.
//  Copyright © 2019 Alborghette. All rights reserved.
//

import UIKit

enum MovieBusinessResponse {
    case success(MovieListModel)
    case failure(Error)
}

protocol MovieBusinessProtocol {
    typealias MovieBusinessCompletion = (MovieBusinessResponse) -> Void
    
    func getMovies(page: Int, completion: @escaping MovieBusinessCompletion)
}

class MovieBusiness: MovieBusinessProtocol {
    
    var network: NetworkProtocol
    
    init() {
        network = Network(withBaseUrl: TheMovieDbConfiguration.baseUrl, andAPIConfiguration: TheMovieDbConfiguration.apiConfiguration)
    }
    
    func getMovies(page: Int, completion: @escaping MovieBusinessCompletion) {
        
        let queryParams = [ "page": page ]
        
        network.get(resource: "movie/upcoming", params: queryParams) { (response) in
            switch response {
            case .success(let data):
                do {
                    let movieList = try JSONDecoder().decode(MovieListModel.self, from: data)
                    completion(.success(movieList))
                } catch {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
        
    }
    
}
