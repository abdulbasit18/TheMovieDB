//
//  MoviesRepository.swift
//  TheMovieDB
//
//  Created by Abdul Basit on 11/26/19.
//  Copyright © 2019 Abdul Basit. All rights reserved.
//

import Foundation
import RxSwift

//MARK: - Protocols
protocol MoviesRepositoryInputs: class {
    var getMoviesSubject: PublishSubject<MovieRequestModel> { get }
}

protocol MoviesRepositoryOutputs: class {
    var fetchMovieSubject: PublishSubject<MovieResponseModel> { get }
    var FailWithErrorSubject: PublishSubject<FailedMoviesErrorType> { get }
}

protocol MoviesRepositoryProtocol: MoviesRepositoryInputs, MoviesRepositoryOutputs {
    var inputs: MoviesRepositoryInputs { get }
    var outputs: MoviesRepositoryOutputs { get }
}

//MARK: - MoviesRepository Implementation
final class MoviesRepository: MoviesRepositoryProtocol {
    
    var outputs: MoviesRepositoryOutputs { self}
    var inputs: MoviesRepositoryInputs { self }
    
    //MARK: - Inputs
    var fetchMovieSubject = PublishSubject<MovieResponseModel>()
    var FailWithErrorSubject = PublishSubject<FailedMoviesErrorType>()
    
    //MARK: - Outputs
    var getMoviesSubject = PublishSubject<MovieRequestModel>()
    
    //MARK: - Properties
    private let remoteMoviesDataSource: MoviesRemoteDataStoreProtocol
    private let localMoviesDataSource: MoviesLocalDataSourceProtocol
    private let disposeBag = DisposeBag()
    
    //MARK: - Initialisers
    init(remoteMoviesDataSource: MoviesRemoteDataStoreProtocol, localMoviesDataSource: MoviesLocalDataSourceProtocol) {
        self.remoteMoviesDataSource = remoteMoviesDataSource
        self.localMoviesDataSource = localMoviesDataSource
        
        //MARK: - Setup Rx Bindings
        setupBindings()
    }
    
    //MARK: - Bindingas
    private func setupBindings() {
        /*Shared Subject of movies which will
        be shared between local data store and to output the fetched movies*/
        let sharedMoviesSubject = self.remoteMoviesDataSource.outputs.fetchMovieSubject.share(replay: 1, scope: .whileConnected)
        
        //Update local database when movies are fetched
        sharedMoviesSubject
            .compactMap{$0.movies}
            .bind(to: self.localMoviesDataSource.saveMoviesSubject)
            .disposed(by: disposeBag)
        
        //Output the fetched movies data
        sharedMoviesSubject
            .bind(to: outputs.fetchMovieSubject).disposed(by: disposeBag)
        
        //Trigger the local database fetch in case of error
        self.remoteMoviesDataSource.outputs.failWithErrorSubject
            .map{(error: $0, id: nil)}
            .bind(to: localMoviesDataSource.inputs.getMoviesWithIdSubject)
            .disposed(by: disposeBag)
        
        //Fetch movies data from local database in case of error
        self.localMoviesDataSource.outputs.getMoviesSubject
            .bind(to: outputs.FailWithErrorSubject)
            .disposed(by: disposeBag)
        
        //Call fetch movies when triggered
        self.inputs.getMoviesSubject
            .bind(to: remoteMoviesDataSource.inputs.getMoviesSubject)
            .disposed(by: disposeBag)
    }
}

