//
//  Predicate.swift
//  TheMovieDB
//
//  Created by Abdul Basit on 11/25/19.
//  Copyright © 2019 Abdul Basit. All rights reserved.
//

import Foundation

struct Predicate{
    var format : String
    var arguments : [Any]
    init(format : String , arguments : [Any]) {
        self.format = format
        self.arguments = arguments
    }
}
