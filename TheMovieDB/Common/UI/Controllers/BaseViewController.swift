//
//  BaseViewController.swift
//  TheMovieDB
//
//  Created by Abdul Basit on 11/30/19.
//  Copyright © 2019 Abdul Basit. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class BaseViewController: UIViewController, NVActivityIndicatorViewable, AlertsPresentable {

    var noInternetHeaderView: NoInternetHeaderView!
    let reachability = Reachability()
    var boundsObserver: NSKeyValueObservation?

    override func viewDidLoad() {
        super.viewDidLoad()
        setNoInternetHeaderView()
        setReachability()
        
        boundsObserver = navigationController?.navigationBar.layer
            .observe(\.bounds, changeHandler: { [weak self](_, _) in
                guard let self = self else { return }
                self.noInternetHeaderView.frame = CGRect(x: 0, y: self.topbarHeight,
                                                         width: UIScreen.main.bounds.width,
                                                         height: 40)
            })
    }

    private func setNoInternetHeaderView() {
        noInternetHeaderView = NoInternetHeaderView.loadNib()
        noInternetHeaderView.isHidden = true
        self.view.addSubview(noInternetHeaderView)
    }

    private func setReachability() {
        reachability?.whenReachable = { [weak self] _  in
            guard let self = self else { return }
            if !(self.noInternetHeaderView.isHidden) {
                self.noInternetHeaderView.isHidden.toggle()
            }
        }

        reachability?.whenUnreachable = { _ in
            if (self.noInternetHeaderView.isHidden) {
                self.noInternetHeaderView.isHidden.toggle()
            }
        }
        try? reachability?.startNotifier()
    }

}
