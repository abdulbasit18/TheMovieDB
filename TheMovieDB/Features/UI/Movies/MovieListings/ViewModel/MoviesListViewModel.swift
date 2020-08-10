//
//  MoviesListViewModel.swift
//  TheMovieDB
//
//  Created by Abdul Basit on 11/26/19.
//  Copyright © 2019 Abdul Basit. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

//MARK: - Types
typealias AlertType = (title: String, message: String)

//MARK: - Protocols
protocol MoviesListViewModelInputs: class {
    var viewDidLoadSubject: PublishSubject<Void?> { get }
    var tapOnCellSubject: PublishSubject<Int> { get }
    var reachedBottomSubject: PublishSubject<Void?> { get }
    func getMovieListCellViewModel(for index: Int) -> MovieListCellViewModel
}

protocol MoviesListViewModeOutputs : class {
    var animateLoaderSubject: PublishSubject<Bool?> { get }
    var alertSubject: PublishSubject<AlertType> { get }
    var dataSubject: BehaviorRelay<[MoviesSection]> { get }
    var title: String { get }
}

protocol MoviesListViewModelProtocol: MoviesListViewModelInputs, MoviesListViewModeOutputs {
    var inputs: MoviesListViewModelInputs { get }
    var outputs: MoviesListViewModeOutputs { get }
}

//MARK: - MoviesListViewModel Implementation
final class MoviesListViewModel: MoviesListViewModelProtocol {
    
    var inputs: MoviesListViewModelInputs { self }
    var outputs: MoviesListViewModeOutputs { self }
    
    //MARK: - Inputs
    var viewDidLoadSubject = PublishSubject<Void?>()
    var tapOnCellSubject = PublishSubject<Int>()
    var reachedBottomSubject = PublishSubject<Void?>()
    
    //MARK: - Outputs
    var alertSubject =  PublishSubject<AlertType>()
    var animateLoaderSubject = PublishSubject<Bool?>()
    var dataSubject = BehaviorRelay<[MoviesSection]>(value: [])
    var title: String { "The MovieDB" }
    
    //MARK: - Properties
    private let moviesService: MoviesServiceProtocol
    private let navigator: MoviesListNavigatorProtocol
    private let numberOfSections = 1
    private var fetchedFromLocalStorage = false
    private let disposeBag = DisposeBag()
    
    //MARK: - Initilizers
    init(moviesService: MoviesServiceProtocol, navigator: MoviesListNavigatorProtocol) {
        self.moviesService = moviesService
        self.navigator = navigator
        
        //Setup Rx Bindings
        setupBindings()
    }
    
    //MARK: - Bindings
    private func setupBindings() {
        
        //Load initial calls on viewDidLoad
        self.inputs.viewDidLoadSubject.subscribe { [weak self] (_) in
            self?.loadView()
        }.disposed(by: disposeBag)
        
        //Call services on reaching collection view scroll bottom
        self.inputs.reachedBottomSubject
            .debounce(.milliseconds(100), scheduler: MainScheduler.instance)
            .subscribe { [weak self] (_) in
                self?.loadView()
        }.disposed(by: disposeBag)
        
        //Call tap handle
        self.inputs.tapOnCellSubject.subscribe(onNext: { [weak self] (index) in
            self?.didTapOnCell(index: index)
        }).disposed(by: disposeBag)
        
        //Handle loader view
        self.moviesService.outputs.cantFetchMovieSubject.subscribe { [weak self] (_) in
            self?.outputs.animateLoaderSubject.onNext(false)
        }.disposed(by: disposeBag)
        
        // Get movies from service
        self.moviesService.outputs.didFetchMoviesSubject.subscribe(onNext: { [weak self] (movies) in
            guard let self = self else { return }
            let oldMoviesData = self.getMovies()
            let latestValues = oldMoviesData + movies
            let movieSection = MoviesSection(header: "", items: latestValues)
            self.dataSubject.accept([movieSection])
            self.fetchedFromLocalStorage = false
            self.outputs.animateLoaderSubject.onNext(false)
        }).disposed(by: disposeBag)
        
        // Get data from service in case of an error
        self.moviesService.outputs.didFailWithErrorSubject.subscribe(onNext: { [weak self] (movies) in
            guard let self = self else { return }
            let movieSection = MoviesSection(header: "", items: movies.movies)
            self.dataSubject.accept([movieSection])
            self.outputs.animateLoaderSubject.onNext(false)
            self.fetchedFromLocalStorage = true
            if movies.movies.isEmpty {
                self.outputs.alertSubject.onNext((title:"Nothing Found", message: "We couldn't found any movies, please try later"))
                return
            }
        }).disposed(by: disposeBag)
    }
    
    //MARK: - Actions
    func getMovieListCellViewModel(for index: Int) -> MovieListCellViewModel {
        let movie = getMovies()[index]
        let title = movie.title ?? ""
        let movieImageURL = Constants.API.imageBaseURL + (movie.posterPath ?? "")
        return createMovieListCellViewModel(movieImageURL: movieImageURL , title: title)
    }
    
    private func createMovieListCellViewModel(movieImageURL: String, title: String) -> MovieListCellViewModel {
        return MovieListCellViewModel(movieImageUrl: URL(string: movieImageURL)!, title: title, placeHolderImage: "placeholder")
    }
    
    private func loadView() {
        if !fetchedFromLocalStorage {
            self.outputs.animateLoaderSubject.onNext(true)
            moviesService.inputs.getMoviesSubject.onNext(nil)
        }
    }
    
    private func didTapOnCell(index: Int) {
        navigator.navigateToDetail(with: getMovies()[index])
    }
    
    private func getMovies() -> [MovieDTO] {
        let data = self.dataSubject.value.first?.items ?? []
        return data
    }
}
