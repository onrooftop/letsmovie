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
        
        self.service.request(router: .movie(id: "\(self.id)", appendToResponses: [.credits]))
            .map{ try? JSONDecoder().decode(Movie.self, from: $0) }
            .subscribe(onSuccess: { (movie) in
                guard let movie = movie else { return }
                var detailSection: SectionViewModel
                var castSection: SectionViewModel
                
                //MARK: Detail Section
                let movieHeaderViewModel = MovieHeaderViewModel(movie: movie)
                let movieGenreViewModel = MovieGenreViewModel(movie: movie)
                let movieOverviewVieModel = MovieOverviewViewModel(movie: movie)
                detailSection = SectionViewModel(header: movieHeaderViewModel, items: [movieGenreViewModel, movieOverviewVieModel])
                
                //MARK: Cast Section
                let movieCreditHeaderViewModel = MovieCreditHeaderViewModel(creditType: .cast)
                let movieCastViewModels = MovieCastViewModel.from(movie: movie)
                castSection = SectionViewModel(header: movieCreditHeaderViewModel, items: movieCastViewModels)
                
                self.sections.onNext([
                    detailSection,
                    castSection
                ])
            })
            .disposed(by: disposeBag)
    }
}
