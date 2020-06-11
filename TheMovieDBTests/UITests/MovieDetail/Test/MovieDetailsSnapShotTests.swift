//
//  MovieDetailsSnapShotTests.swift
//  TheMovieDBTests
//
//  Created by Abdul Basit on 12/1/19.
//  Copyright © 2019 Abdul Basit. All rights reserved.
//

import FBSnapshotTestCase
@testable import TheMovieDB

class MovieDetailsSnapShotTests: FBSnapshotTestCase {

    override func setUp() {
        super.setUp()
    }

    func testWhenAllDataIsFilled() {
        let storyboard = UIStoryboard(storyboard: .movies)
        let movieDetailController: MovieDetailViewController = storyboard.instantiateViewController()
        let movieData = MovieDetailData(title: "Sherlock", releaseData: "11-12-2019", showAdultLabel: false, overview: "Story of detective", imageURL: URL(string: Constants.API.imageBaseURL)!, rating: "10", placeholderImage: "placeholder")
        let vm = MockMovieDetailsViewModel(movieData: movieData)
        vm.delegate = movieDetailController
        movieDetailController.viewModel = vm
        FBSnapshotVerifyView(movieDetailController.view)
    }

    func testWhenAllDataIsFilledButShowAdultFieldIsTrue() {
        let storyboard = UIStoryboard(storyboard: .movies)
        let movieDetailController: MovieDetailViewController = storyboard.instantiateViewController()
        let movieData = MovieDetailData(title: "Sherlock", releaseData: "11-12-2019", showAdultLabel: true, overview: "Story of detective", imageURL: URL(string: Constants.API.imageBaseURL)!, rating: "10", placeholderImage: "placeholder")
        let vm = MockMovieDetailsViewModel(movieData: movieData)
        vm.delegate = movieDetailController
        movieDetailController.viewModel = vm
        FBSnapshotVerifyView(movieDetailController.view)
    }

    func testWhenAllDataIsFilledButRelaseDateIsMissing() {
        let storyboard = UIStoryboard(storyboard: .movies)
        let movieDetailController: MovieDetailViewController = storyboard.instantiateViewController()
        let movieData = MovieDetailData(title: "Sherlock", releaseData: "", showAdultLabel: true, overview: "Story of detective", imageURL: URL(string: Constants.API.imageBaseURL)!, rating: "10", placeholderImage: "placeholder")
        let vm = MockMovieDetailsViewModel(movieData: movieData)
        vm.delegate = movieDetailController
        movieDetailController.viewModel = vm
        FBSnapshotVerifyView(movieDetailController.view)
    }

    func testWhenAllDataIsFilledButTitleIsMissing() {
        let storyboard = UIStoryboard(storyboard: .movies)
        let movieDetailController: MovieDetailViewController = storyboard.instantiateViewController()
        let movieData = MovieDetailData(title: "", releaseData: "11-12-2019", showAdultLabel: true, overview: "Story of detective", imageURL: URL(string: Constants.API.imageBaseURL)!, rating: "10", placeholderImage: "placeholder")
        let vm = MockMovieDetailsViewModel(movieData: movieData)
        vm.delegate = movieDetailController
        movieDetailController.viewModel = vm
        FBSnapshotVerifyView(movieDetailController.view)
    }

    func testWhenAllDataIsFilledButOverviewIsMissing() {
        let storyboard = UIStoryboard(storyboard: .movies)
        let movieDetailController: MovieDetailViewController = storyboard.instantiateViewController()
        let movieData = MovieDetailData(title: "Sherlock", releaseData: "11-12-2019", showAdultLabel: true, overview: "", imageURL: URL(string: Constants.API.imageBaseURL)!, rating: "10", placeholderImage: "placeholder")
        let vm = MockMovieDetailsViewModel(movieData: movieData)
        vm.delegate = movieDetailController
        movieDetailController.viewModel = vm
        FBSnapshotVerifyView(movieDetailController.view)
    }

    func testWhenAllDataIsFilledButRatingIsMissing() {
        let storyboard = UIStoryboard(storyboard: .movies)
        let movieDetailController: MovieDetailViewController = storyboard.instantiateViewController()
        let movieData = MovieDetailData(title: "Sherlock", releaseData: "11-12-2019", showAdultLabel: true, overview: "Story of detective", imageURL: URL(string: Constants.API.imageBaseURL)!, rating: "", placeholderImage: "placeholder")
        let vm = MockMovieDetailsViewModel(movieData: movieData)
        vm.delegate = movieDetailController
        movieDetailController.viewModel = vm
        FBSnapshotVerifyView(movieDetailController.view)
    }

    func testWhenAllDataIsFilledButPlaceholderIsMissing() {
        let storyboard = UIStoryboard(storyboard: .movies)
        let movieDetailController: MovieDetailViewController = storyboard.instantiateViewController()
        let movieData = MovieDetailData(title: "Sherlock", releaseData: "11-12-2019", showAdultLabel: true, overview: "Story of detective", imageURL: URL(string: Constants.API.imageBaseURL)!, rating: "10", placeholderImage: "")
        let vm = MockMovieDetailsViewModel(movieData: movieData)
        vm.delegate = movieDetailController
        movieDetailController.viewModel = vm
        FBSnapshotVerifyView(movieDetailController.view)
    }

    func testWhenAllDataIsMissing() {
        let storyboard = UIStoryboard(storyboard: .movies)
        let movieDetailController: MovieDetailViewController = storyboard.instantiateViewController()
        let movieData = MovieDetailData(title: "", releaseData: "", showAdultLabel: false, overview: "", imageURL: URL(string: Constants.API.imageBaseURL)!, rating: "", placeholderImage: "")
        let vm = MockMovieDetailsViewModel(movieData: movieData)
        vm.delegate = movieDetailController
        movieDetailController.viewModel = vm
        FBSnapshotVerifyView(movieDetailController.view)
    }
}
