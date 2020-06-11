//
//  MovieRemoteDataStore.swift
//  TheMovieDB
//
//  Created by Abdul Basit on 11/25/19.
//  Copyright © 2019 Abdul Basit. All rights reserved.
//

import Foundation

protocol MoviesRemoteDataStoreDelegate: class {
    func didFetchMovie(movies : MovieResponseModel)
    func didFailWithError(error: Error)
}

protocol MoviesRemoteDataStoreProtocol {
    var delegate: MoviesRemoteDataStoreDelegate? { get set }
    func getMovies(parameters: MovieRequestModel)
}

final class MoviesRemoteDataStore: MoviesRemoteDataStoreProtocol {

    weak var delegate: MoviesRemoteDataStoreDelegate?
    private let networkManager: Networking
    private let endpoint = "movie/now_playing"

    init(networkManager: Networking = NetworkManager(), delegate: MoviesRemoteDataStoreDelegate? = nil) {
        self.delegate = delegate
        self.networkManager = networkManager
    }

    func getMovies(parameters: MovieRequestModel) {
        let path = APIPathBuilder(baseURL: Constants.API.baseURL, endPoint: endpoint)
        let request = RequestBuilder(path: path, parameters: parameters)

        networkManager.get(request: request) { [weak self] (response: APIResponse<MovieResponseModel>)  in
            guard let self = self else { return }

            switch response.result {
            case .success(let data):
                self.delegate?.didFetchMovie(movies: data)
            case .failure(let error):
                self.delegate?.didFailWithError(error: error)
            }
        }
    }

}
