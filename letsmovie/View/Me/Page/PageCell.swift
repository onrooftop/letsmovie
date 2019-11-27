//
//  PageController.swift
//  letsmovie
//
//  Created by Panupong Kukutapan on 14/11/2562 BE.
//  Copyright © 2562 Panupong Kukutapan. All rights reserved.
//

import UIKit

class PageCell: UICollectionViewCell, UsableViewModel {
    
    var pageController = PosterController()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    
        setupPageController()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var viewModel: MePosterViewModel!
    var bindedViewModel: ViewModelType!
    func bindViewModel() {
        viewModel = (bindedViewModel as? MePosterViewModel)
        
        pageController.bind(viewModel: viewModel)
    }
}

//MARK:- UI Elements
extension PageCell {
    private func setupPageController() {
        let pageControllerView = pageController.view!
        pageControllerView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(pageControllerView)
        NSLayoutConstraint.activate([
            pageControllerView.topAnchor.constraint(equalTo: topAnchor),
            pageControllerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            pageControllerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            pageControllerView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
