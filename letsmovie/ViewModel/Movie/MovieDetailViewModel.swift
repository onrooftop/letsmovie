//
//  MovieDetailViewModel.swift
//  letsmovie
//
//  Created by Panupong Kukutapan on 23/11/2562 BE.
//  Copyright © 2562 Panupong Kukutapan. All rights reserved.
//

import Foundation

class MovieDetailViewModel: ViewModelType {
    
    private let movieDetail: MovieDetail
    init(movie: Movie) {
        self.movieDetail = MovieDetail(movie: movie)
    }
}
