//
//  TheMovieDbConfiguration.swift
//  movies
//
//  Created by Murilo Alves Alborghette on 8/19/19.
//  Copyright © 2019 Alborghette. All rights reserved.
//

import Foundation

struct TheMovieDbConfiguration {
    static let baseUrl = "https://api.themoviedb.org/3/"
    static let apiConfiguration = [
        "api_key": "1f54bd990f1cdfb230adb312546d765d",
        "language": "en-US"
    ]
    static let imageBaseUrl = "https://image.tmdb.org/t/p/%@%@"
}
