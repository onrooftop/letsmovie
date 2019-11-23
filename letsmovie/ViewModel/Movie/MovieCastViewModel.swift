//
//  MovieCastViewModel.swift
//  letsmovie
//
//  Created by Panupong Kukutapan on 23/11/2562 BE.
//  Copyright © 2562 Panupong Kukutapan. All rights reserved.
//

import Foundation
import RxSwift

class MovieCastViewModel: ViewModelType, CellIdentifier {
    
    static var cellIdentifier: String = "movieCastViewModel"
    
    let cast: Observable<(character: String, name: String, profilePath: String?)>
    
    private let movieCast: MovieCast
    init(movieCast: Movie.Cast) {
        self.movieCast = MovieCast(movieCast: movieCast)
        
        cast = .just((character: self.movieCast.character, name: self.movieCast.name, profilePath: self.movieCast.profilePath))
    }
}


extension MovieCastViewModel {
    class func from(movie: Movie) -> [MovieCastViewModel] {
        
        return movie.credits.cast.map { MovieCastViewModel(movieCast: $0) }
    }
}
