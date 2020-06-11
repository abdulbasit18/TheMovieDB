//
//  MoviesListCoordinator.swift
//  TheMovieDB
//
//  Created by Osama Bashir on 11/26/19.
//  Copyright © 2019 Osama Bashir. All rights reserved.
//

import UIKit

protocol MoviesListNavigatorProtocol {
    func navigateToDetail(movie: MovieDTO)
}

struct MoviesListNavigator: MoviesListNavigatorProtocol {

    let navigation: UINavigationController

    init(navigation: UINavigationController) {
        self.navigation = navigation
    }

    func navigateToDetail(movie: MovieDTO) {
        
    }
}


