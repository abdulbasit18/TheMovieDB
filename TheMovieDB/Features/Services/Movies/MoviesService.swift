//
//  MovieService.swift
//  TheMovieDB
//
//  Created by Abdul Basit on 11/26/19.
//  Copyright © 2019 Abdul Basit. All rights reserved.
//

import Foundation
import RxSwift

//MARK: - Protocols
protocol MoviesServiceInputs: class {
    var getMoviesSubject: PublishSubject<Void?> { get }
}

protocol MoviesServiceOutputs: class {
    var didFetchMoviesSubject: PublishSubject<[MovieDTO]> { get }
    var didFailWithErrorSubject: PublishSubject<FailedMoviesErrorType> { get }
    var cantFetchMovieSubject: PublishSubject<Void?> { get }
}

protocol MoviesServiceProtocol: MoviesServiceInputs, MoviesServiceOutputs {
    var inputs: MoviesServiceInputs { get }
    var outputs: MoviesServiceOutputs { get }
}

//MARK: - MoviesService Implementation
final class MoviesService: MoviesServiceProtocol {
    
    var inputs: MoviesServiceInputs { self }
    var outputs: MoviesServiceOutputs { self }
    
    //MARK: - Inputs
    var getMoviesSubject = PublishSubject<Void?>()
    
    //MARK: - Outputs
    var didFetchMoviesSubject = PublishSubject<[MovieDTO]>()
    var didFailWithErrorSubject = PublishSubject<FailedMoviesErrorType>()
    var cantFetchMovieSubject = PublishSubject<Void?>()
    
    //MARK: - Properties
    private var movieResponse: MovieResponseModel?
    private let moviesRepository: MoviesRepositoryProtocol
    private let disposeBag = DisposeBag()
    
    //MARK: - Initilizers
    init(moviesRepository: MoviesRepositoryProtocol) {
        self.moviesRepository = moviesRepository
        
        //Setup Rx Bindings
        setupBindings()
    }
    
    //MARK: - Bindings
    private func setupBindings() {
        /*Shared Subject of movies which will
         be shared between local local movies object and to output the fetched movies*/
        let sharedMovieSubject = self.moviesRepository.outputs.fetchMovieSubject.share(replay: 1, scope: .whileConnected)
        
        //Output Movies Data
        sharedMovieSubject
            .compactMap{$0.movies}
            .bind(to: outputs.didFetchMoviesSubject)
            .disposed(by: disposeBag)
        
        //Save Data locally
        sharedMovieSubject.subscribe(onNext: { [weak self] (movies) in
            self?.movieResponse = movies
        }).disposed(by: disposeBag)
        
        //Output Data in case of an error
        self.moviesRepository.outputs.FailWithErrorSubject
            .bind(to: outputs.didFailWithErrorSubject)
            .disposed(by: disposeBag)
        
        //Get Movies input call
        inputs.getMoviesSubject.subscribe(onNext: { [weak self] (_) in
            guard let self = self else { return }
            self.getMoviesData()
        }).disposed(by: disposeBag)
    }
}

//MARK: - Extensions
extension MoviesService {
    
    //Outputs movies data
    private func getMoviesData() {
        (canFetchMovies()) ?
            fetchMovies(page: (movieResponse?.page ?? 0) + 1, apiKey: Constants.Keys.api) :
            cantFetchMovies()
    }
    
    // Check if movies data can be fetched
    private func canFetchMovies() -> Bool {
        guard let movieResponse = movieResponse,
            (movieResponse.page != nil),
            (movieResponse.totalPages != nil) else { return true }
        return (movieResponse.page! == movieResponse.totalPages!) ? false : true
    }
    
    //Get movies
    private func fetchMovies(page: Int, apiKey: String) {
        let moviesRequestModel = MovieRequestModel(page: page, api_key: apiKey)
        self.moviesRepository.inputs.getMoviesSubject.onNext(moviesRequestModel)
    }
    
    //Output movies can not be fetched
    private func cantFetchMovies() {
        outputs.cantFetchMovieSubject.onNext(nil)
    }
    
}
