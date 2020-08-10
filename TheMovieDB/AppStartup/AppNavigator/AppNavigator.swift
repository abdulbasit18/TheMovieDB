//
//  AppNavigator.swift
//  TheMovieDB
//
//  Created by Abdul Basit on 11/26/19.
//  Copyright © 2019 Abdul Basit. All rights reserved.
//

import UIKit

protocol AppNavigatorProtocol {
    func installRoot(in window: UIWindow)
}

struct AppNavigator { //: AppNavigatorProtocol {

    func installRoot(into window: UIWindow) {
        // controller create & setup
        let storyboard = UIStoryboard(storyboard: .movies)
        let movieListController: MovieListViewController = storyboard.initialViewController()
        let rootController = AppNavigationController(rootViewController: movieListController)
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let coreDataManager = CoreDataManger(context: context)
        //View Model create & setup
        let remoteDataSource = MoviesRemoteDataStore()
        let localDataSource = MoviesLocalDataSource(localDBManager: coreDataManager)
        let repository = MoviesRepository(remoteMoviesDataSource: remoteDataSource, localMoviesDataSource: localDataSource)
        let service = MoviesService(moviesRepository: repository)
        let navigator = MoviesListNavigator(navigationController: rootController)
        let viewModel = MoviesListViewModel(moviesService: service, navigator: navigator)

        movieListController.viewModel = viewModel

        window.rootViewController = rootController
    }
}
