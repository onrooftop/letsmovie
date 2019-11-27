//
//  MePosterViewModel.swift
//  letsmovie
//
//  Created by Panupong Kukutapan on 27/11/2562 BE.
//  Copyright © 2562 Panupong Kukutapan. All rights reserved.
//

import Foundation
import RxSwift
import RealmSwift

class MePosterViewModel: ViewModelType, CellIdentifier{
    static var cellIdentifier: String = "MePosterViewModel"
 
    let posterViewModels: Observable<[PosterViewModel]>
    init(posterViewModels: [PosterViewModel]) {
        self.posterViewModels = .just(posterViewModels)
    }
}

extension MePosterViewModel {
    static func from(pageType: MePage, userMovie: Results<UserMovie>) -> MePosterViewModel {
        let posterViewModels: [PosterViewModel] = userMovie
            .filter { pageType.userMovieStatusCompare(with: $0.userMovieStatus) }
            .map { PosterViewModel(id: $0.id, urlString: $0.posterUrlPath) }
        
        return MePosterViewModel(posterViewModels: posterViewModels)
    }
}
