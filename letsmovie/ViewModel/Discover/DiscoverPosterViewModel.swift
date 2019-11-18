//
//  DiscoverPosterViewModel.swift
//  letsmovie
//
//  Created by Panupong Kukutapan on 18/11/2562 BE.
//  Copyright © 2562 Panupong Kukutapan. All rights reserved.
//

import Foundation
import RxSwift

class DiscoverPosterViewModel {
    //MARK: Input
    let discoverType: PublishSubject<DiscoverType>
    let loadMoreData: PublishSubject<Void>
    
    //MARK: Output
    let posters: BehaviorSubject<[DiscoverResult]>
    
    private let pageNumber: BehaviorSubject<Int>
    private let disposeBag = DisposeBag()
    private let service: NetworkSession
    private var discoverPosters: [DiscoverPoster] = []
    private var discoverResults: [DiscoverResult] = []
    private var currentPage = 0
    
    init(networkSession: NetworkSession) {
        self.service = networkSession
        
        discoverType = PublishSubject<DiscoverType>()
        loadMoreData = PublishSubject<Void>()
        
        posters = BehaviorSubject(value: [])
        pageNumber = BehaviorSubject(value: 1)
        
        Observable.combineLatest(discoverType.asObserver(), pageNumber.asObserver())
            .asObservable()
            .flatMap { self.service.request(discoverType: $0, page: $1) }
            .map{ try! JSONDecoder().decode(DiscoverPoster.self, from: $0) }
            .subscribe(onNext: { [unowned self] (discoverPoster) in
                self.discoverPosters.append(discoverPoster)
                self.discoverResults += discoverPoster.results
                self.posters.onNext(self.discoverResults)
            })
            .disposed(by: disposeBag)

        
        loadMoreData
            .flatMap{ Observable.just(self.currentPage + 1) }
            .bind(to: pageNumber)
            .disposed(by: disposeBag)
        
        pageNumber.subscribe(onNext: { [unowned self] (page) in
            self.currentPage = page
        })
        .disposed(by: disposeBag)

    }
}
