//
//  MovieCrewViewModel.swift
//  letsmovie
//
//  Created by Panupong Kukutapan on 24/11/2562 BE.
//  Copyright © 2562 Panupong Kukutapan. All rights reserved.
//

import Foundation
import RxSwift

class MovieCrewViewModel: ViewModelType {
    
    let name: Observable<String>
    let job: Observable<String>
    let profilePath: Observable<String>
    
    private let movieCrew: MovieCrew
    init(movieCrew: Movie.Crew) {
        self.movieCrew = MovieCrew(movieCrew: movieCrew)
        
        self.name = .just(self.movieCrew.name)
        self.job = .just(self.movieCrew.job)
        self.profilePath = .just(self.movieCrew.profilePath ?? "")
    }
}

extension MovieCrewViewModel {
    static func from(movie: Movie) -> [MovieCrewViewModel] {
        let jobFilter = ["Director"]
        return movie.credits.crew
            .filter {jobFilter.contains($0.job)}
            .map {MovieCrewViewModel(movieCrew: $0)}
    }
}
