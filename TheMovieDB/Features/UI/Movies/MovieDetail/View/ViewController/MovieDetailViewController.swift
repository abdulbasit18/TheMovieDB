//
//  MovieDetailViewController.swift
//  TheMovieDB
//
//  Created by Abdul Basit on 11/30/19.
//  Copyright © 2019 Abdul Basit. All rights reserved.
//

import UIKit

class MovieDetailViewController: BaseViewController {

    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet private weak var movieImageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var releaseDateLabel: UILabel!
    @IBOutlet private weak var adultContentLabel: UILabel!
    @IBOutlet private weak var overviewLabel: UILabel!
    @IBOutlet private weak var rating: UILabel!

    var viewModel: MovieDetailViewModelProtocol!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        viewModel.viewDidLoad()
    }

    private func setupUI() {
        self.title = "The MovieDB"
        titleLabel.font = UIFont(.avenirDemiBold, size: .standard(.h1))
        titleLabel.textAlignment = .center
        releaseDateLabel.font = UIFont(.avenirDemiBold, size: .standard(.h6))
        releaseDateLabel.textAlignment = .left
        overviewLabel.font = UIFont(.avenirDemiBold, size: .standard(.h6))
        overviewLabel.textAlignment = .left
        rating.font = UIFont(.avenirDemiBold, size: .standard(.h6))
        rating.textAlignment = .left
        movieImageView.contentMode = .scaleToFill
    }
}

extension MovieDetailViewController: MovieDetailViewModelDelegate {

    func fillUI(with data: MovieDetailData) {
        titleLabel.text = data.title
        releaseDateLabel.text = data.releaseData
        adultContentLabel.isHidden = !data.showAdultLabel
        overviewLabel.text = data.overview
        rating.text = data.rating
        movieImageView.sd_setImage(with: data.imageURL, placeholderImage: UIImage(named: data.placeholderImage), completed: nil)
    }

}
