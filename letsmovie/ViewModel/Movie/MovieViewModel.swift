//
//  MovieViewModel.swift
//  letsmovie
//
//  Created by Panupong Kukutapan on 23/11/2562 BE.
//  Copyright © 2562 Panupong Kukutapan. All rights reserved.
//

import Foundation
import RxSwift

class MovieViewModel: ViewModelType {
    
    private(set) var sectionsArray: [SectionViewModel]
    
    private let sections: BehaviorSubject<[SectionViewModel]>
    public var sectionViewModels: Observable<[SectionViewModel]> {
        return sections
    }
    
    private let service: NetworkSession
    private let database: UserMovieStorageType
    private let id: Int
    private let disposeBag: DisposeBag
    init(id: Int, service: NetworkSession, database: UserMovieStorageType = UserMovieStorage.shared) {
        self.service = service
        self.database = database
        self.id = id
        self.disposeBag = DisposeBag()
        self.sections = BehaviorSubject<[SectionViewModel]>(value: [])
        self.sectionsArray = []
        
        let movieData = self.service.request(router: .movie(id: "\(self.id)", appendToResponses: [.credits]))
            .map{ try? JSONDecoder().decode(Movie.self, from: $0) }
            .asObservable()
            .share()
        
        let userMovieData = database.findUserMovie(by: id)
        
        let createUserMovie = Observable.combineLatest(userMovieData.asObservable(), movieData.asObservable())
            .flatMap { (userMovie, movie) -> Observable<UserMovie> in
                guard userMovie == nil else { return .just(userMovie!) }
                let newUserMovie = UserMovie()
                newUserMovie.id = id
                newUserMovie.posterUrlPath = movie!.posterPath
                return database.createOrUpdateUserMovie(userMovie: newUserMovie)
            }
            .share()
        
        let isFetching = Observable.combineLatest(
                movieData.asObservable().map { _ in false },
                createUserMovie.map{ _ in false }
            )
            .startWith((true, true))
            .map{ $0 == false && $1 == false }
        
        isFetching
            .withLatestFrom(movieData)
            .subscribe(onNext: { (movie) in
                guard let movie = movie else { return }
                var detailSection: SectionViewModel
                var castSection: SectionViewModel
                var crewSection: SectionViewModel
                //MARK: Detail Section
                let movieHeaderViewModel = MovieHeaderViewModel(movie: movie)
                let movieButtonsViewModel = MovieButtonsViewModel(id: id, database: database)
                let movieGenreViewModel = MovieGenreViewModel(movie: movie)
                let movieOverviewVieModel = MovieOverviewViewModel(movie: movie)
                detailSection = SectionViewModel(header: movieHeaderViewModel, items: [movieButtonsViewModel, movieGenreViewModel, movieOverviewVieModel])
                
                //MARK: Crew Section
                let movieCrewHeaderViewModel = MovieCreditHeaderViewModel(creditType: .crew)
                let movieCrewViewModels = MovieCreditViewModel.from(movie: movie, creditType: .crew)
                crewSection = SectionViewModel(header: movieCrewHeaderViewModel, items: movieCrewViewModels)
                //MARK: Cast Section
                let movieCastHeaderViewModel = MovieCreditHeaderViewModel(creditType: .cast)
                let movieCastViewModels = MovieCreditViewModel.from(movie: movie, creditType: .cast)
                castSection = SectionViewModel(header: movieCastHeaderViewModel, items: movieCastViewModels)
                
                self.sectionsArray = [
                    detailSection,
                    crewSection,
                    castSection
                ]
                
                self.sections.onNext(self.sectionsArray)
            })
            .disposed(by: disposeBag)
    }
}
