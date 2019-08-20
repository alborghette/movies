//
//  MovieListModel.swift
//  movies
//
//  Created by Murilo Alves Alborghette on 8/19/19.
//  Copyright © 2019 Alborghette. All rights reserved.
//

import Foundation

class MovieListModel: Codable {
    
    var page: Int
    var totalResults: Int
    var totalPages: Int
    var results: [MovieModel]
    
    private enum CodingKeys: String, CodingKey {
        case totalResults = "total_results"
        case totalPages = "total_pages"
        case page
        case results
    }
    
}
