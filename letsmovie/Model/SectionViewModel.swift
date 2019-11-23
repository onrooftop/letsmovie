//
//  SectionViewmidel.swift
//  letsmovie
//
//  Created by Panupong Kukutapan on 23/11/2562 BE.
//  Copyright © 2562 Panupong Kukutapan. All rights reserved.
//

import Foundation
import RxDataSources

struct SectionViewModel {
    var header: ViewModelType
    var items: [ViewModelType]
}

extension SectionViewModel: SectionModelType {
    init(original: SectionViewModel, items: [ViewModelType]) {
        self = original
    }
}
