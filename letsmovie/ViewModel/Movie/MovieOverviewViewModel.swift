//
//  MovieOverviewViewModel.swift
//  letsmovie
//
//  Created by Panupong Kukutapan on 23/11/2562 BE.
//  Copyright © 2562 Panupong Kukutapan. All rights reserved.
//

import Foundation
import RxSwift

class MovieOverviewViewModel: ViewModelType, CellIdentifier {

    static var cellIdentifier: String = "MovieOverviewViewModel"

    let overview: Observable<String>
    
    private let movieOverview: MovieOverview
    init(movie: Movie) {
        self.movieOverview = MovieOverview(movie: movie)
    
        overview = .just(self.movieOverview.overview)
    }
}
