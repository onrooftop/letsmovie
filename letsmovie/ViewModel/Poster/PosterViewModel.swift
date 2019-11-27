//
//  PosterViewModel.swift
//  letsmovie
//
//  Created by Panupong Kukutapan on 24/11/2562 BE.
//  Copyright © 2562 Panupong Kukutapan. All rights reserved.
//

import Foundation
import RxSwift

class PosterViewModel: ViewModelType, CellIdentifier {
    static var cellIdentifier: String = "PosterViewModel"
    
    let urlString: Observable<String>
    let id: Observable<Int>
    let key: Int
    init(id: Int, urlString: String?) {
        self.urlString = .just(urlString ?? "")
        self.id = .just(id)
        self.key = id
    }
}
