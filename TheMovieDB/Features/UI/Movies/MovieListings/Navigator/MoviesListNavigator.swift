//
//  MoviesListNavigator.swift
//  TheMovieDB
//
//  Created by Abdul Basit on 11/26/19.
//  Copyright © 2019 Abdul Basit. All rights reserved.
//

import UIKit

protocol MoviesListNavigatorProtocol {
    func navigateToDetail(with movie: MovieDTO)
}


class MoviesListNavigator: MoviesListNavigatorProtocol {
    private weak var navigationController: UINavigationController?

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func navigateToDetail(with movie: MovieDTO) {
        // controller create & setup
        let storyboard = UIStoryboard(storyboard: .movies)
        let movieDetailController: MovieDetailViewController = storyboard.instantiateViewController()
        //View Model create & setup
        let viewModel = MovieDetailViewModel(movie: movie)
        movieDetailController.viewModel = viewModel
        viewModel.delegate = movieDetailController
        navigationController?.pushViewController(movieDetailController, animated: true)
    }

}
