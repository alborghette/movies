//
//  MovieModel.swift
//  movies
//
//  Created by Murilo Alves Alborghette on 8/19/19.
//  Copyright © 2019 Alborghette. All rights reserved.
//

import Foundation

class MovieModel: Codable {

    var id: Int
    var posterPath: String?
    var backdropPath: String?
    var title: String
    var genreIds: [Int]
    var releaseDate: String
    var overview: String
    
    private enum CodingKeys: String, CodingKey {
        case id
        case posterPath = "poster_path"
        case backdropPath = "backdrop_path"
        case title
        case genreIds = "genre_ids"
        case releaseDate = "release_date"
        case overview
    }
    
}
