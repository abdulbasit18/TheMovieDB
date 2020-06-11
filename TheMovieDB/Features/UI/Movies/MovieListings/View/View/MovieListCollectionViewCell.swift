//
//  MovieListCollectionViewCell.swift
//  TheMovieDB
//
//  Created by Abdul Basit on 11/26/19.
//  Copyright © 2019 Abdul Basit. All rights reserved.
//

import UIKit
import SDWebImage

class MovieListCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet private weak var movieImageView: UIImageView!
    @IBOutlet private weak var movieTitleLabel: UILabel!

    var viewModel: MovieListCellViewModel! {
        didSet {
            setupUI()
            configureCell(viewModel: viewModel)
        }
    }

    private func setupUI() {
        movieImageView.contentMode = .scaleToFill
        movieTitleLabel.textColor = .white
        movieTitleLabel.backgroundColor = .black
        movieTitleLabel.font = UIFont(.avenirDemiBold, size: .standard(.h5))
    }

    private func configureCell(viewModel: MovieListCellViewModel) {
        movieImageView.sd_setImage(with: viewModel.movieImageUrl, placeholderImage: UIImage(named: viewModel.placeHolderImage), completed: nil)
        movieTitleLabel.text = viewModel.title
    }

}
