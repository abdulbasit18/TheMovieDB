//
//  ViewController.swift
//  TheMovieDB
//
//  Created by Abdul Basit on 11/24/19.
//  Copyright © 2019 Abdul Basit. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
import RxSwift
import RxDataSources

final class MovieListViewController: BaseViewController {
    
    //MARK: - IBOutlets
    @IBOutlet weak private var collectionView: UICollectionView!
    
    //MARK: - Properties
    var viewModel: MoviesListViewModelProtocol!
    private let searchController = UISearchController(searchResultsController: nil)
    private let disposeBag = DisposeBag()
    

    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Setup UI
        setCollectionView()
        setupUI()
        
        //Setup RX Bindings
        setupBindings()
    }
    
    //MARK: - Setup UI
    private func setupUI() {
        self.view.backgroundColor = .black
        self.title = viewModel.outputs.title
        viewModel.inputs.viewDidLoadSubject.onNext(nil)
        
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Movies"
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    
    private func setCollectionView() {
        collectionView.rx.setDelegate(self).disposed(by: disposeBag)
        collectionView.backgroundColor = .clear
    }
    
    //MARK: - Setup Bindings
    private func setupBindings() {
        
        searchController.searchBar.rx.searchButtonClicked.subscribe { (_) in
            print("Search Button Action")
        }.disposed(by: disposeBag)
        
        viewModel.outputs.animateLoaderSubject.subscribe(onNext: { [weak self] (shouldLoad) in
            guard let self = self, let shouldLoad = shouldLoad else { return}
            shouldLoad ? self.startAnimating() : self.stopAnimating()
        }).disposed(by: disposeBag)
        
        viewModel.outputs.alertSubject.subscribe(onNext: { [weak self] (alertResponse) in
            self?.showAlert(with: alertResponse.title, and: alertResponse.message)
        }).disposed(by: disposeBag)
        
        viewModel.outputs.dataSubject.subscribe(onNext: { (_) in
            self.collectionView.reloadData()
        }).disposed(by: disposeBag)
        
        collectionView.rx.reachedBottom.asObservable()
            .bind(to: viewModel.inputs.reachedBottomSubject)
            .disposed(by: disposeBag)
        
        
        let dataSource = RxCollectionViewSectionedAnimatedDataSource<MoviesSection>(
            configureCell:{ [weak self] dataSource, tableView, indexPath, item in
                let cell: MovieListCollectionViewCell = (self?.collectionView.dequeueReusableCell(for: indexPath))!
                cell.viewModel = self?.viewModel.inputs.getMovieListCellViewModel(for: indexPath.row)
                return cell
        })
        
        dataSource.canMoveItemAtIndexPath = { dataSource, indexPath in
            return true
        }
        
        viewModel.dataSubject
            .bind(to: collectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
    }
}

extension MovieListViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        viewModel.inputs.tapOnCellSubject.onNext(indexPath.row)
    }
}

extension MovieListViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.sizeForItem(numberOfCellsInRow: 2,
                                          collectionViewLayout: collectionViewLayout
        )
    }
}
