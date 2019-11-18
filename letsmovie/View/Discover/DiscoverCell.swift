//
//  DiscoverCell.swift
//  letsmovie
//
//  Created by Panupong Kukutapan on 14/11/2562 BE.
//  Copyright © 2562 Panupong Kukutapan. All rights reserved.
//

import UIKit

class DiscoverCell: UICollectionViewCell {
    
    var discoverPosterController = DiscoverPosterController()
    var discoverType: DiscoverType! {
        didSet {
            let discoverPosterViewModel = DiscoverPosterViewModel(networkSession: ApiManager.shared, discoverType: discoverType)
            discoverPosterController.bind(viewModel: discoverPosterViewModel)

        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    
        setupView()
        setupUIElements()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK:- UI Elements
extension DiscoverCell {
    private func setupView() {
        backgroundColor = .white
    }
    
    private func setupUIElements() {
        let discoverPosterControllerView = discoverPosterController.view!
        addSubview(discoverPosterControllerView)
        discoverPosterControllerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            discoverPosterControllerView.topAnchor.constraint(equalTo: topAnchor),
            discoverPosterControllerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            discoverPosterControllerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            discoverPosterControllerView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
    }
}
