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

class MeViewModel: ViewModelType {
    private let disposeBag = DisposeBag()
    
    private let sections: ReplaySubject<[SectionViewModel]>
    var sectionViewModels: Observable<[SectionViewModel]> {
        return sections
    }
    
    private let database: UserMovieStorageType
    init(database: UserMovieStorageType = UserMovieStorage.shared) {
        self.database = database
        self.sections = ReplaySubject<[SectionViewModel]>.create(bufferSize: 1)
        
        database.UserMovieList()
            .subscribe(onNext: { (userMovieResutls) in
                let watchlistViewModel = MePosterViewModel.from(pageType: .watchlist, userMovie: userMovieResutls)
                let watchedViewModel = MePosterViewModel.from(pageType: .watched, userMovie: userMovieResutls)
                let sections = [
                    SectionViewModel(header: nil,
                                     items: [
                                        watchlistViewModel,
                                        watchedViewModel
                    ])
                ]
                
                self.sections.onNext(sections)
            })
            .disposed(by: disposeBag)
    }
}
