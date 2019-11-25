//
//  DiscoverHeaderViewModel.swift
//  letsmovie
//
//  Created by Panupong Kukutapan on 24/11/2562 BE.
//  Copyright © 2562 Panupong Kukutapan. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import Action

class DiscoverHeaderViewModel: ViewModelType, CellIdentifier {
    static var cellIdentifier: String = "DiscoverHeaderViewModel"
    
    let title: Driver<String>
    
    private let discoverType: DiscoverType
    private let performSeeAll: Action<DiscoverType, Void>?
    init(discoverType: DiscoverType, performSeeAll: Action<DiscoverType, Void>? = nil) {
        self.discoverType = discoverType
        self.performSeeAll = performSeeAll
        self.title = .just(self.discoverType.rawValue)
    }
    
    lazy var seeAllAction: CocoaAction = {
        return CocoaAction {
            self.performSeeAll?.execute(self.discoverType)
            return .empty()
        }
    }()
}
