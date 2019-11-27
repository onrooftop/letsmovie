//
//  MePosterViewModel.swift
//  letsmovie
//
//  Created by Panupong Kukutapan on 27/11/2562 BE.
//  Copyright © 2562 Panupong Kukutapan. All rights reserved.
//

import Foundation
import RxSwift
import RealmSwift
import Action

class MePosterViewModel: ViewModelType, CellIdentifier{
    static var cellIdentifier: String = "MePosterViewModel"
 
    let posterViewModels: Observable<[PosterViewModel]>
    private(set) var pageType: MePage
    private let posters: [PosterViewModel]
    private let performMovie: Action<MovieViewModel, Void>?
    private let service: NetworkSession
    private let database: UserMovieStorageType
    init(mePageType: MePage, posterViewModels: [PosterViewModel], performMovie: Action<MovieViewModel, Void>?, service: NetworkSession, database: UserMovieStorageType) {
        self.service = service
        self.database = database
        self.posterViewModels = .just(posterViewModels)
        self.pageType = mePageType
        self.posters = posterViewModels
        self.performMovie = performMovie
    }
    
    lazy var movieAction: Action<IndexPath, Void> = {
        return Action<IndexPath, Void> { [unowned self] input in
            let keyId = self.posters[input.item].key
            self.performMovie?.execute(MovieViewModel(id: keyId, service: self.service, database: self.database))
            return .empty()
        }
    }()
}

extension MePosterViewModel {
    static func from(pageType: MePage, userMovie: Results<UserMovie>, performMovie: Action<MovieViewModel, Void>?, service: NetworkSession, database: UserMovieStorageType) -> MePosterViewModel {
        let posterViewModels: [PosterViewModel] = userMovie
            .filter { pageType.userMovieStatusCompare(with: $0.userMovieStatus) }
            .map { PosterViewModel(id: $0.id, urlString: $0.posterUrlPath) }
        
        return MePosterViewModel(mePageType: pageType, posterViewModels: posterViewModels, performMovie: performMovie, service: service, database: database)
    }
}
