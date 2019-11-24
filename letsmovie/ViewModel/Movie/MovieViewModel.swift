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
    private let id: Int
    private let disposeBag: DisposeBag
    init(id: Int, service: NetworkSession) {
        self.service = service
        self.id = id
        self.disposeBag = DisposeBag()
        self.sections = BehaviorSubject<[SectionViewModel]>(value: [])
        self.sectionsArray = []
        
        self.service.request(router: .movie(id: "\(self.id)", appendToResponses: [.credits]))
            .map{ try? JSONDecoder().decode(Movie.self, from: $0) }
            .subscribe(onSuccess: { (movie) in
                guard let movie = movie else { return }
                var detailSection: SectionViewModel
                var castSection: SectionViewModel
                var crewSection: SectionViewModel
                //MARK: Detail Section
                let movieHeaderViewModel = MovieHeaderViewModel(movie: movie)
                let movieButtonsViewModel = MovieButtonsViewModel()
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
