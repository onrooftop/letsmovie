//
//  MovieGenreViewModel.swift
//  letsmovie
//
//  Created by Panupong Kukutapan on 23/11/2562 BE.
//  Copyright © 2562 Panupong Kukutapan. All rights reserved.
//

import Foundation
import RxSwift

class MovieGenreViewModel: ViewModelType, CellIdentifier  {
    
    static var cellIdentifier: String = "movieGenreViewModel"

    let genres: Observable<[String]>
    
    private let movieGenre: MovieGenre

    init(movie: Movie) {
        self.movieGenre = MovieGenre(movie: movie)
        
        genres = .just(self.movieGenre.genres.map{ $0.name })
    }
}
