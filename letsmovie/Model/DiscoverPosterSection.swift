//
//  DiscoverPosterSection.swift
//  letsmovie
//
//  Created by Panupong Kukutapan on 19/11/2562 BE.
//  Copyright © 2562 Panupong Kukutapan. All rights reserved.
//

import Foundation
import RxDataSources

struct DiscoverPosterSection {
    var header: String
    var items: [DiscoverResult]
}

extension DiscoverPosterSection: SectionModelType {
    typealias Item = DiscoverResult

    init(original: DiscoverPosterSection, items: [DiscoverResult]) {
        self.items = items
        self = original
    }
}
