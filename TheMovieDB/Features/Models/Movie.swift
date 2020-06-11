//
//  Movie.swift
//  TheMovieDB
//
//  Created by Abdul Basit on 11/24/19.
//  Copyright © 2019 Abdul Basit. All rights reserved.
//

import Foundation

struct MovieDTO: Decodable {

    let id: Int
    let title: String?
    let voteAverage: Double?
    let posterPath: String?
    let originalTitle: String?
    let adult: Bool?
    let overview: String?
    let releaseDate: String?

    private enum CodingKeys: String, CodingKey {
        case id
        case title
        case voteAverage = "vote_average"
        case posterPath = "poster_path"
        case originalTitle = "original_title"
        case adult
        case overview
        case releaseDate = "release_date"
    }

}
