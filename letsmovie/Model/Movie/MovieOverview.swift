//
//  MovieOverview.swift
//  letsmovie
//
//  Created by Panupong Kukutapan on 23/11/2562 BE.
//  Copyright © 2562 Panupong Kukutapan. All rights reserved.
//

import Foundation

struct MovieOverview {
    let overview: String
    
    init(movie: Movie) {
        self.overview = movie.overview
    }
}
