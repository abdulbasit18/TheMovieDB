//
//  MoviesRepository.swift
//  TheMovieDB
//
//  Created by Abdul Basit on 11/26/19.
//  Copyright © 2019 Abdul Basit. All rights reserved.
//

import Foundation

protocol MoviesRepositoryDelegate: class {
    func didFetchMovie(movies : MovieResponseModel)
    func didFailWithError(movies:[MovieDTO], error: Error)
}

protocol MoviesRepositoryProtocol {
    var delegate: MoviesRepositoryDelegate? { get set }
    func getMovies(parameters: MovieRequestModel)
}

final class MoviesRepository: MoviesRepositoryProtocol {
    weak var delegate: MoviesRepositoryDelegate?
    private let remoteMoviesDataSource: MoviesRemoteDataStoreProtocol
    private let localMoviesDataSource: MoviesLocalDataSourceProtocol

    init(remoteMoviesDataSource: MoviesRemoteDataStoreProtocol, localMoviesDataSource: MoviesLocalDataSourceProtocol, delegate: MoviesRepositoryDelegate? = nil) {
        self.remoteMoviesDataSource = remoteMoviesDataSource
        self.localMoviesDataSource = localMoviesDataSource
        self.delegate = delegate
    }

    func getMovies(parameters: MovieRequestModel) {
        remoteMoviesDataSource.getMovies(parameters: parameters)
    }

}

extension MoviesRepository: MoviesRemoteDataStoreDelegate {

    // MARK:- MoviesRemoteDataStoreDelegate
    func didFetchMovie(movies: MovieResponseModel) {
        delegate?.didFetchMovie(movies: movies)
        guard let moviesData = movies.movies else { return }
        localMoviesDataSource.deleteAllMovies()
        localMoviesDataSource.saveMovies(movies: moviesData)
    }

    func didFailWithError(error: Error) {
        let movies = localMoviesDataSource.getMovies(id: nil)
        delegate?.didFailWithError(movies: movies, error: error)
    }
}

