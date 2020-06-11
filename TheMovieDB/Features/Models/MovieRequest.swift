//
//  MovieRequest.swift
//  TheMovieDB
//
//  Created by Abdul Basit on 11/24/19.
//  Copyright © 2019 Abdul Basit. All rights reserved.
//

import Foundation

struct MovieRequestModel: Encodable {
    let page: Int
    let api_key: String
}
