//
//  SearchMovieCellViewModel.swift
//  letsmovie
//
//  Created by Panupong Kukutapan on 28/11/2562 BE.
//  Copyright © 2562 Panupong Kukutapan. All rights reserved.
//

import Foundation
import RxSwift

class SearchMovieCellViewModel: ViewModelType, CellIdentifier {
    static var cellIdentifier: String = "SearchMovieCellViewModel"
    
    let movieTitle: Observable<String>
    
    private let id: Int
    private let title: String
    init(id: Int, title: String) {
        self.id = id
        self.title = title
        
        movieTitle = .just(title)
    }
}
