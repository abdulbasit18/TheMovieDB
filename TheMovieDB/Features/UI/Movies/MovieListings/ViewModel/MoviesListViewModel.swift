//
//  MoviesListViewModel.swift
//  TheMovieDB
//
//  Created by Abdul Basit on 11/26/19.
//  Copyright © 2019 Abdul Basit. All rights reserved.
//

import Foundation
import RxSwift

protocol MoviesListViewModelDelegate: class {
    func animateLoader()
    func stopLoader()
    func reloadData()
    func alert(with title: String, message: String)
}

protocol MoviesListViewModelProtocol {
    var delegate: MoviesListViewModelDelegate? { get set }
    var numberOfRows: Int { get }
    var sections: Int { get }
    var title: String { get }
    var isLast: Bool { get set }
    
    func viewDidLoad()
    func didTapOnCell(index: Int)
    func getMovieListCellViewModel(for index: Int) -> MovieListCellViewModel
}

final class MoviesListViewModel: MoviesListViewModelProtocol {
    
    weak var delegate: MoviesListViewModelDelegate?
    var numberOfRows: Int { return getMovies().count }
    var sections: Int { return 1 }
    var title: String { return "The MovieDB" }
    var isLast: Bool = false {
        didSet {
            if isLast {
                moviesService.getMovies()
            }
        }
    }
    
    private var remoteMovies: [MovieDTO] = []
    private var localMovies: [MovieDTO] = []
    private let moviesService: MoviesServiceProtocol
    private let navigator: MoviesListNavigatorProtocol
    private let numberOfSections = 1
    private var fetchedFromLocalStorage = false
    
    init(moviesService: MoviesServiceProtocol, navigator: MoviesListNavigatorProtocol, delegate: MoviesListViewModelDelegate? = nil) {
        self.moviesService = moviesService
        self.delegate = delegate
        self.navigator = navigator
    }
    
    func viewDidLoad() {
        delegate?.animateLoader()
        moviesService.getMovies()
    }
    
    func didTapOnCell(index: Int) {
        navigator.navigateToDetail(with: getMovies()[index])
    }
    
    func getMovieListCellViewModel(for index: Int) -> MovieListCellViewModel {
        let movie = getMovies()[index]
        let title = movie.title ?? ""
        let movieImageURL = Constants.API.imageBaseURL + (movie.posterPath ?? "")
        return createMovieListCellViewModel(movieImageURL: movieImageURL , title: title)
    }
    
    private func createMovieListCellViewModel(movieImageURL: String, title: String) -> MovieListCellViewModel {
        return MovieListCellViewModel(movieImageUrl: URL(string: movieImageURL)!, title: title, placeHolderImage: "placeholder")
    }
    
    private func getMovies() -> [MovieDTO] {
        return (fetchedFromLocalStorage) ? localMovies : remoteMovies
    }
}

extension MoviesListViewModel: MoviesServiceDelegate {
    // MARK:- MoviesRepositoryDelegate
    func didFetchMovies(movies: [MovieDTO]) {
        remoteMovies += movies
        fetchedFromLocalStorage = false
        delegate?.reloadData()
        delegate?.stopLoader()
    }
    
    func didFailWithError(movies: [MovieDTO], error: Error) {
        localMovies = movies
        delegate?.stopLoader()
        
        if (localMovies.count == 0 && self.remoteMovies.count == 0) {
            delegate?.alert(with: "Nothing Found", message: "We couldn't found any movies, please try later")
            return
        }
        
        if (movies.count == 0) {
            delegate?.reloadData()
            fetchedFromLocalStorage = true
            return
        }
    }
    
    func cantFetchMovie() {
        delegate?.stopLoader()
    }
}
