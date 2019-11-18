//
//  DiscoverSeeAllController.swift
//  letsmovie
//
//  Created by Panupong Kukutapan on 19/11/2562 BE.
//  Copyright © 2562 Panupong Kukutapan. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class DiscoverSeeAllController: UIViewController, ViewModelBindableType {
    
    var viewModel: DiscoverPosterViewModel!
    let disposeBag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        setupNavigationController()
    }
    
    func bindViewModel() {
        viewModel.title
            .bind(to: navigationItem.rx.title)
            .disposed(by: disposeBag)
    }
}

extension DiscoverSeeAllController {
    func setupView() {
        view.backgroundColor = .white
    }
    
    func setupNavigationController() {
        navigationItem.setHidesBackButton(true, animated: true)
    }
}
