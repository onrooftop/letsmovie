//
//  MovieButtonsViewModel.swift
//  letsmovie
//
//  Created by Panupong Kukutapan on 24/11/2562 BE.
//  Copyright © 2562 Panupong Kukutapan. All rights reserved.
//

import Foundation
import RxSwift
import Action

typealias ButtonStatus = (isWatchlistHidden: Bool, isWatchedHidden: Bool, shouldAnimate: Bool)
class MovieButtonsViewModel: ViewModelType, CellIdentifier {
    
    static var cellIdentifier: String = "movieButtonsViewModel"
    
    var buttonsStatus: Observable<ButtonStatus> {
        return buttons
    }
    private let buttons: BehaviorSubject<ButtonStatus>
    private var isWatchlistHidden = false
    private var isWatchedHidden = false
    init() {

        self.buttons = BehaviorSubject<ButtonStatus>(value: (
            isWatchlistHidden: self.isWatchlistHidden,
            isWatchedHidden: self.isWatchedHidden,
            shouldAnimate: false
        ))
    }
    
    lazy var watchlistAction: CocoaAction = {
        return CocoaAction {
            self.isWatchedHidden = !self.isWatchedHidden
            self.buttons.onNext((
                isWatchlistHidden: self.isWatchlistHidden,
                isWatchedHidden: self.isWatchedHidden,
                shouldAnimate: true
            ))
            return .empty()
        }
    }()
    
    lazy var watchedAction: CocoaAction = {
        return CocoaAction {
            self.isWatchlistHidden = !self.isWatchlistHidden
            self.buttons.onNext((
                isWatchlistHidden: self.isWatchlistHidden,
                isWatchedHidden: self.isWatchedHidden,
                shouldAnimate: true
            ))
            return .empty()
        }
    }()
}
