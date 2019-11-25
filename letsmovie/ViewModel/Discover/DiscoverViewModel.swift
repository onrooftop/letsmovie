//
//  DiscoverViewModel.swift
//  letsmovie
//
//  Created by Panupong Kukutapan on 15/11/2562 BE.
//  Copyright © 2562 Panupong Kukutapan. All rights reserved.
//

import Foundation
import RxSwift
import Action
import RxCocoa

class DiscoverViewModel: ViewModelType {
    
    private let viewModels: ReplaySubject<[SectionViewModel]>
    var sectionViewModels: Observable<[SectionViewModel]> {
        return viewModels.asObservable()
    }
    
    private let seeAll: PublishSubject<DiscoverPosterViewModel>
    var seeAllViewModel: Observable<DiscoverPosterViewModel> {
        return seeAll
    }
    
    private let movie: PublishSubject<MovieViewModel>
    var movieViewModel: Observable<MovieViewModel> {
        return movie
    }
    
    private let service: NetworkSession
    private(set) var sections: [SectionViewModel]
    
    private var performMovie: Action<Int, Void>?
    private var performSeeAll: Action<DiscoverType, Void>?

    init(service: NetworkSession) {
        self.seeAll = PublishSubject<DiscoverPosterViewModel>()
        self.service = service
        self.sections = []
        self.viewModels = ReplaySubject<[SectionViewModel]>.create(bufferSize: 1)
        self.movie = PublishSubject<MovieViewModel>()
        
        self.performMovie = Action<Int, Void>(workFactory: { (id) -> Observable<Void> in
            self.movie.onNext(MovieViewModel(id: id, service: service))
            return .empty()
        })
        
        self.performSeeAll = Action<DiscoverType, Void>(workFactory: { (dicoverType) -> Observable<Void> in
            self.seeAll.onNext(DiscoverPosterViewModel(networkSession: service, discoverType: dicoverType))
            return .empty()
        })

        let popularSection = SectionViewModel(
            header: DiscoverHeaderViewModel(discoverType: .popular,
                                            performSeeAll: self.performSeeAll),
            items: [DiscoverPosterViewModel(networkSession: service,
                                            discoverType: .popular,
                                            performMovie: self.performMovie)]
        )
        
        let nowPlayingSection = SectionViewModel(
            header: DiscoverHeaderViewModel(discoverType: .nowPlaying,
                                            performSeeAll: self.performSeeAll),
            items: [DiscoverPosterViewModel(networkSession: service,
                                            discoverType: .nowPlaying,
                                            performMovie: self.performMovie)]
        )
        
        let upComingSection = SectionViewModel(
            header: DiscoverHeaderViewModel(discoverType: .upComing,
                                            performSeeAll: self.performSeeAll),
            items: [DiscoverPosterViewModel(networkSession: service,
                                            discoverType: .upComing,
                                            performMovie: self.performMovie)]
        )

        self.sections = [
            popularSection,
            nowPlayingSection,
            upComingSection
        ]
        
        self.viewModels.onNext(self.sections)
        
    }
}
