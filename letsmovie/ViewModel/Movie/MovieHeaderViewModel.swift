//
//  MovieHeaderViewModel.swift
//  letsmovie
//
//  Created by Panupong Kukutapan on 23/11/2562 BE.
//  Copyright © 2562 Panupong Kukutapan. All rights reserved.
//

import Foundation
import RxSwift

class MovieHeaderViewModel: ViewModelType, CellIdentifier {
    
    static var cellIdentifier: String = "movieHeaderViewModel"
    
    let title: Observable<String>
    let backdropUrlString: Observable<String>
    let runtime: Observable<String>
    
    private let movieHeader: MovieHeader
    
    init(movie: Movie) {
        self.movieHeader = MovieHeader(movie: movie)
        
        title = Observable.just(self.movieHeader.title)
        backdropUrlString = Observable.just(self.movieHeader.backdropUrlString)
        runtime = Observable.just("\(self.movieHeader.runtime) min")
    }
}
