//
//  MovieHeader.swift
//  letsmovie
//
//  Created by Panupong Kukutapan on 23/11/2562 BE.
//  Copyright © 2562 Panupong Kukutapan. All rights reserved.
//

import Foundation

struct MovieHeader {
    let title: String
    let backdropUrlString: String
    let runtime: Int

    init(movie: Movie) {
        self.title = movie.title
        self.backdropUrlString = movie.backdropPath
        self.runtime = movie.runtime
    }
}

