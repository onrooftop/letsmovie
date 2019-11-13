//
//  ViewModelBindableType.swift
//  letsmovie
//
//  Created by Panupong Kukutapan on 13/11/2562 BE.
//  Copyright © 2562 Panupong Kukutapan. All rights reserved.
//

import UIKit

protocol ViewModelBindableType {
    associatedtype ViewModel
    var viewModel: ViewModel! { get set }
    
    func bindViewModel()
}

extension ViewModelBindableType where Self: UIViewController {
    mutating func bind(viewMode: ViewModel) {
        self.viewModel = viewModel
        bindViewModel()
        loadViewIfNeeded()
    }
}
