//
//  GenreBusiness.swift
//  movies
//
//  Created by Murilo Alves Alborghette on 8/19/19.
//  Copyright © 2019 Alborghette. All rights reserved.
//

import UIKit

enum GenreBusinessResponse {
    case success(GenreListModel)
    case failure(Error)
}

protocol GenreBusinessProtocol {
    typealias GenreBusinessCompletion = (GenreBusinessResponse) -> Void
    
    func getGenres(completion: @escaping GenreBusinessCompletion)
}

class GenreBusiness: GenreBusinessProtocol {

    var network: NetworkProtocol
    
    init() {
        network = Network(withBaseUrl: TheMovieDbConfiguration.baseUrl, andAPIConfiguration: TheMovieDbConfiguration.apiConfiguration)
    }
    
    func getGenres(completion: @escaping GenreBusinessCompletion) {
        
        network.get(resource: "genre/movie/list", params: [:]) { (response) in
            switch response {
            case .success(let data):
                do {
                    let genreList = try JSONDecoder().decode(GenreListModel.self, from: data)
                    completion(.success(genreList))
                } catch {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
        
    }
    
}
