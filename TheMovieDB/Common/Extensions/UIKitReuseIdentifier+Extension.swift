//
//  UIKitReuseIdentifier+Extension.swift
//  TheMovieDB
//
//  Created by Abdul Basit on 11/26/19.
//  Copyright © 2019 Abdul Basit. All rights reserved.
//

import UIKit

protocol ReuseIdentifying {
    static var reuseIdentifier: String { get }
}

extension ReuseIdentifying {
    static var reuseIdentifier: String {
        return String(describing: Self.self)
    }
}

extension UICollectionViewCell: ReuseIdentifying {}
