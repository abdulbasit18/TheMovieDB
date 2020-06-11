//
//  MoviesLocalDataSource.swift
//  TheMovieDB
//
//  Created by Abdul Basit on 11/25/19.
//  Copyright © 2019 Abdul Basit. All rights reserved.
//

import Foundation

protocol MoviesLocalDataSourceProtocol {
    func getMovies(id: String?) -> [MovieDTO]
    func saveMovies(movies: [MovieDTO])
    func deleteMovies(movies: [MovieDTO])
    func deleteAllMovies()
    func updateMovies(movies: [MovieDTO])
}

final class MoviesLocalDataSource: MoviesLocalDataSourceProtocol {

    let localDBManager: CoreDataManger
    let entity = "Movie"

    init(localDBManager: CoreDataManger) {
        self.localDBManager = localDBManager
    }

    func getMovies(id: String?) -> [MovieDTO] {
        let predicate = (id != nil) ? Predicate(format: "%k == %@", arguments: ["movieId" , id!]) : nil
        let result = localDBManager.fetchObject(entity, predicate: predicate) as! [Movie]
        return result.compactMap(convertMovieToMovieDTO)
    }

    func saveMovies(movies: [MovieDTO]) {
        let _ = movies.compactMap(convertMovieDtoToMovie)
        localDBManager.save(entity: entity)
    }

    func deleteAllMovies() {
        localDBManager.deleteObjects(entity)
    }

    func deleteMovies(movies: [MovieDTO]) {
        movies.forEach(delete)
    }

    func updateMovies(movies: [MovieDTO]) {
        movies.forEach(update)
    }

}

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
