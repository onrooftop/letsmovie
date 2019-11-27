//
//  MeViewModel.swift
//  letsmovie
//
//  Created by Panupong Kukutapan on 27/11/2562 BE.
//  Copyright © 2562 Panupong Kukutapan. All rights reserved.
//

import Foundation
import RxSwift
import RealmSwift
import Action

class MeViewModel: ViewModelType {
    private let disposeBag = DisposeBag()
    
    private let sections: ReplaySubject<[SectionViewModel]>
    var sectionViewModels: Observable<[SectionViewModel]> {
        return sections
    }
    
    private let movie: PublishSubject<MovieViewModel>
    var selectedMovie: Observable<MovieViewModel> {
        return movie
    }
    private(set) var mePages: [MePosterViewModel]
    private var performMovie: Action<MovieViewModel, Void>?
    private let database: UserMovieStorageType
    private let service: NetworkSession
    init(service: NetworkSession, database: UserMovieStorageType = UserMovieStorage.shared) {
        self.service = service
        self.database = database
        self.sections = ReplaySubject<[SectionViewModel]>.create(bufferSize: 1)
        self.mePages = []
        self.movie = PublishSubject<MovieViewModel>()
        self.performMovie = Action<MovieViewModel, Void>(workFactory: { [unowned self] (movieViewModel) -> Observable<Void> in
            self.movie.onNext(movieViewModel)
            return.empty()
        })
        database.UserMovieList()
            .subscribe(onNext: { (userMovieResutls) in
                let watchlistViewModel = MePosterViewModel.from(
                    pageType: .watchlist,
                    userMovie: userMovieResutls,
                    performMovie: self.performMovie,
                    service: self.service,
                    database: self.database
                )
                let watchedViewModel = MePosterViewModel.from(
                    pageType: .watched,
                    userMovie: userMovieResutls,
                    performMovie: self.performMovie,
                    service: self.service,
                    database: self.database
                )
                self.mePages = [
                    watchlistViewModel,
                    watchedViewModel
                ]
                let sections = [
                    SectionViewModel(header: nil,
                                     items: self.mePages)
                ]
                
                self.sections.onNext(sections)
            })
            .disposed(by: disposeBag)
    }
}
