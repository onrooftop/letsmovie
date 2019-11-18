//
//  DiscoverViewModel.swift
//  letsmovie
//
//  Created by Panupong Kukutapan on 15/11/2562 BE.
//  Copyright © 2562 Panupong Kukutapan. All rights reserved.
//

import Foundation
import RxSwift

class DiscoverViewModel {
    //input
    
    //output
    let discoverSections: Observable<[DiscoverSection]>
    
    init() {
        discoverSections = Observable.just([
            DiscoverSection(header: "Popular", items: [.popular]),
            DiscoverSection(header: "Now Playing", items: [.nowPlaying]),
            DiscoverSection(header: "Up Coming", items: [.upComing]),
        ])
    }
}
