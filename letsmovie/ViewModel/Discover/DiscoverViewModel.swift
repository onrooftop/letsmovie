//
//  DiscoverViewModel.swift
//  letsmovie
//
//  Created by Panupong Kukutapan on 15/11/2562 BE.
//  Copyright © 2562 Panupong Kukutapan. All rights reserved.
//

import Foundation
import RxSwift
import Action
import RxCocoa

class DiscoverViewModel: ViewModelType {
    //input
    
    //output
    let discoverSections: Observable<[DiscoverSection]>
    private let seeAll: PublishSubject<DiscoverPosterViewModel>
    
    var seeAllViewModel: Observable<DiscoverPosterViewModel> {
        return seeAll
    }
    
    private let service: NetworkSession
    
    let sections: [DiscoverSection] = [
            DiscoverSection(header: "Popular", items: [.popular]),
            DiscoverSection(header: "Now Playing", items: [.nowPlaying]),
            DiscoverSection(header: "Up Coming", items: [.upComing]),
        ]
    
    init(service: NetworkSession) {
        discoverSections = Observable.just(sections)
        seeAll = PublishSubject<DiscoverPosterViewModel>()
        
        self.service = service
    }
    
    func performSeeAll(section: Int) -> CocoaAction {
        return CocoaAction {
            guard let discoverType = self.sections[section].items.first else {
                return Observable.empty()
            }
            let viewModel = DiscoverPosterViewModel(networkSession: self.service, discoverType: discoverType)
            self.seeAll.onNext(viewModel)
            return Observable.empty()
        }
    }
}
