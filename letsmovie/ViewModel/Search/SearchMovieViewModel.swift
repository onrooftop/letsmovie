//
//  SearchMovieViewModel.swift
//  letsmovie
//
//  Created by Panupong Kukutapan on 28/11/2562 BE.
//  Copyright © 2562 Panupong Kukutapan. All rights reserved.
//

import Foundation
import RxSwift
import Action

class SearchMovieViewModel: ViewModelType {
    private let disposeBag = DisposeBag()
    
    let row: PublishSubject<Int>
    let searchText: PublishSubject<String>
    
    var selectedViewModel: Observable<MovieViewModel> {
        return movieViewModel
    }
    
    var isNoMoivesMessageHidden: Observable<Bool> {
        return noMoviesMessageVisibility
    }
    
    var isFooterHidden: Observable<Bool> {
        return footerVisibility
    }
    var searchResults: Observable<[SearchMovieCellViewModel]> {
        return cellViewModels
    }
    
    let service: NetworkSession
    private let pageNumber: BehaviorSubject<Int>
    private let cellViewModels: BehaviorSubject<[SearchMovieCellViewModel]>
    private let footerVisibility: BehaviorSubject<Bool>
    private let noMoviesMessageVisibility: BehaviorSubject<Bool>
    private let movieViewModel: PublishSubject<MovieViewModel>
    private var searchArray: [(id: Int, title: String)] = []
    private var pageNumberInt: Int = 1
    private var totalPageNumber: Int = 2
    init(service: NetworkSession) {
        self.service = service
        
        pageNumber = BehaviorSubject<Int>(value: pageNumberInt)
        cellViewModels = BehaviorSubject<[SearchMovieCellViewModel]>(value: [])
        footerVisibility = BehaviorSubject<Bool>(value: false)
        noMoviesMessageVisibility = BehaviorSubject<Bool>(value: false)
        movieViewModel = PublishSubject<MovieViewModel>()
        
        searchText = PublishSubject<String>()
        row = PublishSubject<Int>()
        
        let query = searchText.asObserver()
            .debounce(.milliseconds(500), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .compactMap { $0.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) }

        
        let fetchData = Observable.combineLatest(
                query,
                pageNumber.asObserver()
            )
            .flatMapLatest { service.requestSearchMovie(query: $0, page: $1)}
            .share()
        
        let loadMoreData = row.asObserver()
            .map { $0 == self.searchArray.count - 1 }
            .distinctUntilChanged()
        
        loadMoreData
            .filter { $0 == true }
            .subscribe(onNext: { (isLoadMore) in
                self.pageNumberInt += 1
                if self.pageNumberInt <= self.totalPageNumber {
                    self.pageNumber.onNext(self.pageNumberInt)
                }
                self.footerVisibility.onNext(self.pageNumberInt > self.totalPageNumber)
            })
            .disposed(by: disposeBag)
        
        query
            .map { _ in () }
            .subscribe(onNext: {
                self.pageNumberInt = 1
                self.searchArray.removeAll()
                
                self.pageNumber.onNext(self.pageNumberInt)
                self.footerVisibility.onNext(self.searchArray.count < 1)
                self.cellViewModels.onNext([])
                self.noMoviesMessageVisibility.onNext(false)
            })
            .disposed(by: disposeBag)
        
        fetchData
            .compactMap{ try? JSONDecoder().decode(DiscoverPoster.self, from: $0) }
            .subscribeOn(MainScheduler.instance)
            .subscribe(onNext: { (discoverPoster) in
                let searches = discoverPoster.results.map { ($0.id, $0.title) }
                self.totalPageNumber = discoverPoster.totalPages
                self.searchArray += searches
                self.footerVisibility.onNext(self.searchArray.count < 1)
                self.noMoviesMessageVisibility.onNext(self.searchArray.count > 1)
                self.cellViewModels.onNext(
                    self.searchArray.map { SearchMovieCellViewModel(id: $0.id, title: $0.title) }
                )
            })
            .disposed(by: disposeBag)

    }
    
    lazy var selectedItem: Action<IndexPath, Void> = {
        return Action<IndexPath, Void> { indexPath in
            let id = self.searchArray[indexPath.row].id
            self.movieViewModel.onNext(MovieViewModel(id: id, service: self.service))
            return .empty()
        }
    }()
}
