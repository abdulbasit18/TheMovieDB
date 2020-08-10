//
//  MoviesLocalDataSource.swift
//  TheMovieDB
//
//  Created by Abdul Basit on 11/25/19.
//  Copyright © 2019 Abdul Basit. All rights reserved.
//

import Foundation
import RxSwift

//MARK: - Types
internal typealias FailedErrorType = (error: Error, id: String?)
internal typealias FailedMoviesErrorType = (error: Error, movies: [MovieDTO])

//MARK: - Protocols
protocol MoviesLocalDataSourceInputs: class {
    var saveMoviesSubject: PublishSubject<[MovieDTO]> { get }
    var deleteMoviesSubject: PublishSubject<[MovieDTO]> { get }
    var updateMoviesSubject: PublishSubject<[MovieDTO]> { get }
    var deleteAllMoviesSubject: PublishSubject<Void> { get }
    var getMoviesWithIdSubject: PublishSubject<FailedErrorType> { get }
}

protocol MoviesLocalDataSourceOutputs: class {
    var getMoviesSubject: PublishSubject<FailedMoviesErrorType> { get }
}

protocol MoviesLocalDataSourceProtocol: MoviesLocalDataSourceInputs, MoviesLocalDataSourceOutputs {
    var inputs: MoviesLocalDataSourceInputs { get }
    var outputs: MoviesLocalDataSourceOutputs { get }
}

//MARK: - MoviesLocalDataSource Implementation 
final class MoviesLocalDataSource: MoviesLocalDataSourceProtocol {
    
    var inputs: MoviesLocalDataSourceInputs { self}
    var outputs: MoviesLocalDataSourceOutputs { self }
    
    //MARK: - Inputs
    var saveMoviesSubject = PublishSubject<[MovieDTO]>()
    var deleteMoviesSubject = PublishSubject<[MovieDTO]>()
    var updateMoviesSubject = PublishSubject<[MovieDTO]>()
    var deleteAllMoviesSubject = PublishSubject<Void>()
    var getMoviesWithIdSubject = PublishSubject<FailedErrorType>()
    
    //MARK: - Outputs
    var getMoviesSubject = PublishSubject<FailedMoviesErrorType>()
    
    //MARK: - Properties
    private let disposeBag = DisposeBag()
    private let localDBManager: CoreDataManger
    private let entity = "Movie"

    //MARK: - Initilizers
    init(localDBManager: CoreDataManger) {
        self.localDBManager = localDBManager
        
        //Setup Rx Binings
        setupBindings()
    }
    
    //MARK: - Bindings
    private func setupBindings() {
        
        //Save Movies on Invocation
        inputs.saveMoviesSubject.subscribe(onNext: { [weak self] (movies) in
            guard let self = self else { return }
            let _ = movies.compactMap(self.convertMovieDtoToMovie)
            self.localDBManager.save(entity: self.entity)
        }).disposed(by: disposeBag)
        
        //Delete All Movies on Invocation
        inputs.deleteAllMoviesSubject.subscribe(onNext: { [weak self] (_) in
            guard let self = self else { return }
            self.localDBManager.deleteObjects(self.entity)
        }).disposed(by: disposeBag)
        
        //Delete Movies on Invocation
        inputs.deleteMoviesSubject.subscribe(onNext: { [weak self] (movies) in
            guard let self = self else { return }
            movies.forEach(self.delete)
        }).disposed(by: disposeBag)
        
        //Update Movies on Invocation
        inputs.updateMoviesSubject.subscribe(onNext: { [weak self] (movies) in
            guard let self = self else { return }
            movies.forEach(self.update)
        }).disposed(by: disposeBag)
        
        //Get Movies with ID on Invocation
        inputs.getMoviesWithIdSubject.subscribe(onNext: { [weak self] (request) in
            guard let self = self else { return }
            let predicate = (request.id != nil) ? Predicate(format: "%k == %@", arguments: ["movieId" , request.id ?? ""]) : nil
            let result = self.localDBManager.fetchObject(self.entity, predicate: predicate) as! [Movie]
            let compactResults = result.compactMap(self.convertMovieToMovieDTO)
            self.outputs.getMoviesSubject.onNext((error: request.error, movies: compactResults))
            
        }).disposed(by: disposeBag)
        
    }
}

//MARK: - Database CRUD Functionality

extension MoviesLocalDataSource {

    // MARK:- Internal Utility methods

    private func delete(movie : MovieDTO) {
        let predicate = Predicate(format: "%k == %@", arguments: ["movieId", String(movie.id)])
        localDBManager.deleteObjects(entity, predicate: predicate )
    }

    private func update(movie: MovieDTO) {
        let predicate = Predicate(format: "%k == %@", arguments: ["movieId", String(movie.id)])
        guard let data = localDBManager.doesThisObjectExist(entity, predicate: predicate) as? Movie
            else { return }
        data.movieId = Int64(movie.id)
        data.title = movie.title
        data.originalTitle = movie.originalTitle
        data.adult = movie.adult ?? false
        data.releaseDate = movie.releaseDate
        data.overview = movie.overview
        data.posterPath = movie.posterPath
        data.voteAverage = movie.voteAverage ?? 0
        localDBManager.save(entity: entity)

    }

    private func convertMovieToMovieDTO(movie: Movie) -> MovieDTO {
        return MovieDTO(id: Int(movie.movieId),
                        title: movie.title,
                        voteAverage: movie.voteAverage,
                        posterPath: movie.posterPath,
                        originalTitle: movie.originalTitle,
                        adult: movie.adult,
                        overview: movie.overview,
                        releaseDate: movie.releaseDate
        )
    }

    private func convertMovieDtoToMovie(movieDTO: MovieDTO) -> Movie {
        return Movie(movieDTO: movieDTO, context: localDBManager.context)
    }
}
