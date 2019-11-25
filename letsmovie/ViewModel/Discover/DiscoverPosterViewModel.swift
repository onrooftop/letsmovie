//
//  DiscoverPosterViewModel.swift
//  letsmovie
//
//  Created by Panupong Kukutapan on 18/11/2562 BE.
//  Copyright © 2562 Panupong Kukutapan. All rights reserved.
//

import Foundation
import RxSwift
import Action

class DiscoverPosterViewModel: ViewModelType, CellIdentifier {
    static var cellIdentifier: String = "DiscoverPosterViewModel"
    
    //MARK: Input
    let discoverType: DiscoverType
    let loadMoreData: PublishSubject<Void>
    let selectedItem: PublishSubject<IndexPath>

    //MARK: Output
    let cannotLoadMore: Observable<Bool>
    let title: Observable<String>
    var sections: Observable<[SectionViewModel]> {
        return posters.asObserver()
    }
    
    private let posters: ReplaySubject<[SectionViewModel]>
    private let pageNumber: BehaviorSubject<Int>
    private let disposeBag = DisposeBag()
    private let service: NetworkSession
    private var discoverResults: [DiscoverResult] = []
    private var posterViewModels: [PosterViewModel] = []
    private var currentPage = 1
    private let totalPage: PublishSubject<Int>
    private let isFetching: Observable<Bool>
    private let fetchData: Observable<Data>
    
    private let performMovie: Action<Int, Void>?
    init(networkSession: NetworkSession, discoverType: DiscoverType, performMovie: Action<Int, Void>? = nil) {
        self.service = networkSession
        self.discoverType = discoverType
        self.loadMoreData = PublishSubject<Void>()
        self.title = Observable.just(discoverType.rawValue)
        self.selectedItem = PublishSubject<IndexPath>()
        self.posters = ReplaySubject<[SectionViewModel]>.create(bufferSize: 1)
        self.pageNumber = BehaviorSubject(value: 1)
        self.totalPage = PublishSubject<Int>()
        self.performMovie = performMovie
        
        fetchData = pageNumber.asObserver()
            .flatMap { networkSession.request(discoverType: discoverType, page: $0) }
            .share(replay: 1, scope: .whileConnected)
        
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
            .subscribeOn(MainScheduler.instance)
            .subscribe(onNext: { [unowned self] (discoverPoster) in
                guard let discoverPoster = discoverPoster else { return }
                self.discoverResults += discoverPoster.results
                self.posterViewModels += discoverPoster.results.map{ PosterViewModel(id: $0.id, urlString: $0.posterPath)}
                self.totalPage.onNext(discoverPoster.totalPages)
                self.posters.onNext([
                    SectionViewModel(header: nil, items: self.posterViewModels)
                ])
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
    
    lazy var movieAction: Action<IndexPath, Void> = {
        return Action<IndexPath, Void> { indexPath in
            let id = self.discoverResults[indexPath.item].id
            self.performMovie?.execute(id)
            return .empty()
        }
    }()
}
