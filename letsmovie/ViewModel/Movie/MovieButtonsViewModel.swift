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
    
    private let disposeBag = DisposeBag()
    static var cellIdentifier: String = "movieButtonsViewModel"
    
    var buttonsStatus: Observable<ButtonStatus> {
        return buttons
    }
    private let buttons: ReplaySubject<ButtonStatus>
    private let updateStatus: PublishSubject<UserMovie.UserMovieStatus>
    private var isWatchlistHidden = false
    private var isWatchedHidden = false
    private let database: UserMovieStorageType
    private var userMovie: UserMovie!
    private var shouldAnimate: Bool
    
    init(id: Int, database: UserMovieStorageType = UserMovieStorage.shared) {
        self.database = database
        self.buttons = ReplaySubject<ButtonStatus>.create(bufferSize: 1)
        self.updateStatus = PublishSubject<UserMovie.UserMovieStatus>()
        self.shouldAnimate = false
        
        let fetchUserMovie = database.findUserMovie(by: id).share()
        let updateUserMovie = updateStatus.asObserver()
            .flatMap { database.updateUserMovieStatus(by: id, with: $0) }
            .share()
        let fetchData = Observable.merge(fetchUserMovie, updateUserMovie)
        
        fetchData
            .subscribe(onNext: { (userMovie) in
                self.userMovie = userMovie
            })
            .disposed(by: disposeBag)
        
        fetchData
            .map { (userMovie) -> ButtonStatus in

                guard let userMovie = userMovie else { return (
                    isWatchlistHidden: false,
                    isWatchedHidden: false,
                    shouldAnimate: false
                )}
                
                self.isWatchlistHidden = false
                self.isWatchedHidden = false
                
                switch userMovie.userMovieStatus {
                case .none:
                    self.isWatchlistHidden = false
                    self.isWatchedHidden = false
                case .watchlist:
                    self.isWatchlistHidden = false
                    self.isWatchedHidden = true
                case .watched:
                    self.isWatchlistHidden = true
                    self.isWatchedHidden = false
                }
                
                let buttonStatus = (
                    isWatchlistHidden: self.isWatchlistHidden,
                    isWatchedHidden: self.isWatchedHidden,
                    shouldAnimate: self.shouldAnimate
                )
                
                self.shouldAnimate = true
                return buttonStatus
            }
            .bind(to: self.buttons)
            .disposed(by: disposeBag)
    }
    
    lazy var watchlistAction: CocoaAction = {
        return CocoaAction {
            self.updateStatus.onNext(self.changeUserMovieStatus(actionType: .watchlist, from: self.userMovie.userMovieStatus))
            return .empty()
        }
    }()
    
    lazy var watchedAction: CocoaAction = {
        return CocoaAction {
            self.updateStatus.onNext(self.changeUserMovieStatus(actionType: .watched, from: self.userMovie.userMovieStatus))
            return .empty()
        }
    }()
}

extension MovieButtonsViewModel {
    enum MovieActionType {
        case watchlist, watched
    }
    
    func changeUserMovieStatus(actionType: MovieActionType, from: UserMovie.UserMovieStatus) -> UserMovie.UserMovieStatus {
        
        //watchlist
        //  .none -> .watchlist
        //  .watchlist -> .none
        //  .watched -> throw
        //
        //watched
        // .none -> .watched
        // .watched -> .none
        // .watchlist -> throw
        
        switch actionType {
        case .watchlist:
            switch from {
            case .none:
                return .watchlist
            case .watchlist:
                return .none
            case .watched:
                //error should not happen
                break
            }
        case .watched:
            switch from {
            case .none:
                return .watched
            case .watchlist:
                //error should not happen
                break
            case .watched:
                return .none
            }
        }

        return .none
    }
}
