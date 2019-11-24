//
//  DiscoverSection.swift
//  letsmovie
//
//  Created by Panupong Kukutapan on 18/11/2562 BE.
//  Copyright © 2562 Panupong Kukutapan. All rights reserved.
//

import Foundation
import RxDataSources

enum DiscoverType: String {
    case popular = "Popular", nowPlaying = "Now Playing", upComing = "Up Coming"
}

struct DiscoverSection {
    var header: String
    var items: [DiscoverType]
}

extension DiscoverSection: SectionModelType {
    typealias Item = DiscoverType

    init(original: DiscoverSection, items: [DiscoverType]) {
        self.items = items
        self = original
    }
}
