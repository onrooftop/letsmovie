//
//  ViewModelBindableType.swift
//  letsmovie
//
//  Created by Panupong Kukutapan on 13/11/2562 BE.
//  Copyright © 2562 Panupong Kukutapan. All rights reserved.
//

import UIKit

protocol UsableViewModel: ViewModelBindableType, ViewModelCastableType { }

protocol ViewModelCastableType {
    associatedtype ViewModel
    var viewModel: ViewModel! { get set }
}

protocol ViewModelBindableType {
    var bindedViewModel: ViewModelType! { get set }
    func bindViewModel()
}

extension ViewModelBindableType {
    mutating func bind(viewModel: ViewModelType) {
        self.bindedViewModel = viewModel
        bindViewModel()
    }
}
