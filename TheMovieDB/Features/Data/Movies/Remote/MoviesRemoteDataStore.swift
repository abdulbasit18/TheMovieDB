//
//  MovieRemoteDataStore.swift
//  TheMovieDB
//
//  Created by Abdul Basit on 11/25/19.
//  Copyright © 2019 Abdul Basit. All rights reserved.
//

import Foundation
import RxSwift

//MARK: - Protocols

protocol MoviesRemoteDataOutputs: class {
    var fetchMovieSubject: PublishSubject<MovieResponseModel> { get }
    var failWithErrorSubject: PublishSubject<Error> { get }
}

protocol MoviesRemoteDataInputs: class {
    var getMoviesSubject: PublishSubject<MovieRequestModel> { get }
}

protocol MoviesRemoteDataStoreProtocol: MoviesRemoteDataInputs , MoviesRemoteDataOutputs {
    var inputs: MoviesRemoteDataInputs { get }
    var outputs: MoviesRemoteDataOutputs { get }
}

//MARK: - MoviesRemoteDataStore Implementation

final class MoviesRemoteDataStore: MoviesRemoteDataStoreProtocol {
    
    var outputs: MoviesRemoteDataOutputs { self }
    var inputs: MoviesRemoteDataInputs { self }
    
    //MARK: - Inputs
    var getMoviesSubject = PublishSubject<MovieRequestModel>()
    var failWithErrorSubject = PublishSubject<Error>()
    //MARK: - OutPuts
    var fetchMovieSubject = PublishSubject<MovieResponseModel>()
    
    //MARK: - Properties
    private let disposeBag = DisposeBag()
    private let networkManager: Networking
    private let endpoint = "movie/now_playing"
    
    //MARK: - Initilizers
    init(networkManager: Networking = NetworkManager()) {
        self.networkManager = networkManager
        
        //Setup Rx Bindings
        setupBindings()
    }
    
    //MARK: - Bindings
    
    private func setupBindings() {
        // Calling movies service on invocation
        inputs.getMoviesSubject.subscribe(onNext: { [weak self] (parameters) in
            self?.getMovies(parameters: parameters)
        }).disposed(by: disposeBag)
    }
    
    //MARK: - Networking
    private func getMovies(parameters: MovieRequestModel) {
        let path = APIPathBuilder(baseURL: Constants.API.baseURL, endPoint: endpoint)
        let request = RequestBuilder(path: path, parameters: parameters)
        
        networkManager.get(request: request) { [weak self] (response: APIResponse<MovieResponseModel>)  in
            guard let self = self else { return }
            switch response.result {
                case .success(let data):
                    self.outputs.fetchMovieSubject.onNext(data)
                case .failure(let error):
                    self.outputs.failWithErrorSubject.onNext(error)
            }
        }
    }
}
