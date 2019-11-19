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
    let discoverType: DiscoverType
    let loadMoreData: PublishSubject<Void>
    
    //MARK: Output
    let cannotLoadMore: Observable<Bool>
    let title: Observable<String>
    var sections: Observable<[DiscoverPosterSection]> {
        return posters
    }
    
    private let posters: PublishSubject<[DiscoverPosterSection]>
    private let pageNumber: BehaviorSubject<Int>
    private let disposeBag = DisposeBag()
    private let service: NetworkSession
    private var discoverPosters: [DiscoverPoster] = []
    private var discoverResults: [DiscoverResult] = []
    private var currentPage = 1
    private let totalPage: PublishSubject<Int>
    private let isFetching: Observable<Bool>
    private let fetchData: Observable<Data>
    
    init(networkSession: NetworkSession, discoverType: DiscoverType) {
        self.service = networkSession
        
        self.discoverType = discoverType
        loadMoreData = PublishSubject<Void>()
        self.title = Observable.just(discoverType.rawValue)
        
        posters = PublishSubject<[DiscoverPosterSection]>()
        pageNumber = BehaviorSubject(value: 490)
        totalPage = PublishSubject<Int>()
        
        fetchData = pageNumber.asObserver()
            .flatMap { networkSession.request(discoverType: discoverType, page: $0) }
        
        isFetching = Observable.merge(
            pageNumber.map { _ in true },
            fetchData.map { _ in false }
        )
        
        cannotLoadMore = Observable.combineLatest(
                pageNumber, totalPage
            )
            .map{ $0 >= $1 }

        
        fetchData
            .map{ try? JSONDecoder().decode(DiscoverPoster.self, from: $0) }
            .filter{ $0 != nil }
            .subscribe(onNext: { [unowned self] (discoverPoster) in
                self.discoverPosters.append(discoverPoster!)
                self.discoverResults += discoverPoster!.results
                self.totalPage.onNext(discoverPoster!.totalPages)
                self.posters.onNext([DiscoverPosterSection(header: "", items: self.discoverResults)])
            })
            .disposed(by: disposeBag)
  
        loadMoreData
            .withLatestFrom(isFetching)
            .filter{ $0 == false}
            .flatMap{ _ in Observable.just(self.currentPage + 1) }
            .bind(to: pageNumber)
            .disposed(by: disposeBag)
        
        pageNumber.subscribe(onNext: { [unowned self] (page) in
            self.currentPage = page
        })
        .disposed(by: disposeBag)

    }
}
