//
//  MovieService.swift
//  TheMovieDB
//
//  Created by Abdul Basit on 11/26/19.
//  Copyright © 2019 Abdul Basit. All rights reserved.
//

import Foundation

protocol MoviesServiceDelegate: class {
    func didFetchMovies(movies: [MovieDTO])
    func didFailWithError(movies: [MovieDTO], error: Error)
    func cantFetchMovie()
}

protocol MoviesServiceProtocol {
    var delegate: MoviesServiceDelegate? { get set }
    func getMovies()
}

final class  MoviesService: MoviesServiceProtocol {

    weak var delegate: MoviesServiceDelegate?
    var movieResponse: MovieResponseModel?
    private let moviesRepository: MoviesRepositoryProtocol

    init(moviesRepository: MoviesRepositoryProtocol) {
        self.moviesRepository = moviesRepository
    }

    func getMovies() {
        (canFetchMovies()) ? fetchMovies(page: (movieResponse?.page ?? 0) + 1, apiKey: Constants.Keys.api) : cantFetchMovies()
    }

    private func canFetchMovies() -> Bool {
        guard let movieResponse = movieResponse, (movieResponse.page != nil), (movieResponse.totalPages != nil) else { return true }
        return (movieResponse.page! == movieResponse.totalPages!) ? false : true
    }

    private func fetchMovies(page: Int, apiKey: String) {
        let moviesRequestModel = MovieRequestModel(page: page, api_key: apiKey)
        moviesRepository.getMovies(parameters: moviesRequestModel)
    }

    private func cantFetchMovies() {
        delegate?.cantFetchMovie()
    }
}

extension MoviesService: MoviesRepositoryDelegate {

    // MARK:- MoviesRepositoryDelegate
    func didFetchMovie(movies: MovieResponseModel) {
        movieResponse = movies
        delegate?.didFetchMovies(movies: movies.movies ?? [])
    }

    func didFailWithError(movies: [MovieDTO], error: Error) {
        delegate?.didFailWithError(movies: movies, error: error)
    }

}

