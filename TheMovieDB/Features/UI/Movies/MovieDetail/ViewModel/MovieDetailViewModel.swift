//
//  MovieDetailViewModel.swift
//  TheMovieDB
//
//  Created by Abdul Basit on 11/30/19.
//  Copyright © 2019 Abdul Basit. All rights reserved.
//

import Foundation

struct MovieDetailData {
    let title: String
    let releaseData: String
    let showAdultLabel: Bool
    let overview: String
    let imageURL: URL
    let rating: String
    let placeholderImage: String
}

protocol MovieDetailViewModelDelegate: class {
    func fillUI(with data: MovieDetailData)
}

protocol MovieDetailViewModelProtocol {
    var delegate: MovieDetailViewModelDelegate? { get set }
    func viewDidLoad()
}

final class MovieDetailViewModel: MovieDetailViewModelProtocol {



    private let movie: MovieDTO
    weak var delegate: MovieDetailViewModelDelegate?

    init(movie: MovieDTO) {
        self.movie = movie
    }

    func viewDidLoad() {
        delegate?.fillUI(with: prepareDataToSend(movie: movie))
    }

    private func prepareDataToSend(movie: MovieDTO) -> MovieDetailData {
        let title =  movie.originalTitle ?? (movie.title ?? "Title not found")
        let releaseDate = (movie.releaseDate != nil) ? "Release Date : \(movie.releaseDate!)" : ""
        let isAdult =  ((movie.adult ?? false))
        let overview = movie.overview ?? ""
        let rating = (movie.voteAverage != nil) ? "Rating : \(movie.voteAverage!)/10" : ""
        let url = URL(string: Constants.API.imageBaseURL + "\(movie.posterPath ?? "")")
        return MovieDetailData(title: title,
                                    releaseData: releaseDate,
                                    showAdultLabel: isAdult,
                                    overview: overview,
                                    imageURL: url!,
                                    rating: rating,
                                    placeholderImage: "placeholder"
        )
    }
}
