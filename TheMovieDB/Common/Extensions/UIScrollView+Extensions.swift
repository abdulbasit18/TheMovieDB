//
//  UIScrollView+Extensions.swift
//  TheMovieDB
//
//  Created by Abdul Basit on 18/07/2020.
//  Copyright © 2020 Osama Bashir. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

extension Reactive where Base: UIScrollView {
    var reachedBottom: ControlEvent<Void> {
        let observable = contentOffset
            .flatMap { [weak base] contentOffset -> Observable<Void> in
                guard let scrollView = base else { return Observable.empty() }
                
                let visibleHeight = scrollView.frame.height -
                    scrollView.contentInset.top -
                    scrollView.contentInset.bottom
                let y = contentOffset.y + scrollView.contentInset.top
                let threshold = max(0.0, scrollView.contentSize.height - visibleHeight)
                
                return y > threshold ? Observable.just(()) : Observable.empty()
        }
        return ControlEvent(events: observable)
    }
}

