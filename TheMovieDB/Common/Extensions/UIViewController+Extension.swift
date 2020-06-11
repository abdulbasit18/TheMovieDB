//
//  UIViewController+Extension.swift
//  TheMovieDB
//
//  Created by Abdul Basit on 11/30/19.
//  Copyright © 2019 Abdul Basit. All rights reserved.
//

import UIKit

extension UIViewController {
    var topbarHeight: CGFloat {
        return UIApplication.shared.statusBarFrame.size.height +
            (self.navigationController?.navigationBar.frame.height ?? 0.0)
    }
}
