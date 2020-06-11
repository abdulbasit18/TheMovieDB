//
//  MockMovieDetailsViewModel.swift
//  TheMovieDBTests
//
//  Created by Abdul Basit on 12/1/19.
//  Copyright © 2019 Abdul Basit. All rights reserved.
//

import Foundation
@testable import TheMovieDB

final class MockMovieDetailsViewModel: MovieDetailViewModelProtocol {
    let movieData: MovieDetailData
    var delegate: MovieDetailViewModelDelegate?

    init(movieData: MovieDetailData) {
        self.movieData = movieData
    }

    func viewDidLoad() {
        delegate?.fillUI(with: movieData)
    }

}
