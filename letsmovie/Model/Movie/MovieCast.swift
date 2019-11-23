//
//  MovieCast.swift
//  letsmovie
//
//  Created by Panupong Kukutapan on 23/11/2562 BE.
//  Copyright © 2562 Panupong Kukutapan. All rights reserved.
//

import Foundation

struct MovieCast {

    let character: String
    let name: String
    let profilePath: String?
    
    init(movieCast: Movie.Cast) {
        self.character = movieCast.character
        self.name = movieCast.name
        self.profilePath = movieCast.profilePath
    }
}


