//
//  MovieResponse.swift
//  TheMovieDB
//
//  Created by Abdul Basit on 11/24/19.
//  Copyright © 2019 Abdul Basit. All rights reserved.
//

import Foundation

struct MovieResponseModel: Decodable {
    let page: Int?
    let totalResults: Int?
    let totalPages: Int?
    let movies: [MovieDTO]?

    private enum CodingKeys: String, CodingKey {
        case page
        case totalResults = "total_results"
        case totalPages = "total_pages"
        case movies = "results"
    }
}
