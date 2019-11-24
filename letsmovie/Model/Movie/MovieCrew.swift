//
//  MovieCrew.swift
//  letsmovie
//
//  Created by Panupong Kukutapan on 24/11/2562 BE.
//  Copyright © 2562 Panupong Kukutapan. All rights reserved.
//

import Foundation

struct MovieCrew {

    let name: String
    let job: String
    let profilePath: String?
    
    init(movieCrew: Movie.Crew) {
        self.name = movieCrew.name
        self.job = movieCrew.job
        self.profilePath = movieCrew.profilePath
    }
}
