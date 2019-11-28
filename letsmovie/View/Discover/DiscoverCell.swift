//
//  DiscoverCell.swift
//  letsmovie
//
//  Created by Panupong Kukutapan on 14/11/2562 BE.
//  Copyright © 2562 Panupong Kukutapan. All rights reserved.
//

import UIKit
import RxSwift

class DiscoverCell: UICollectionViewCell, UsableViewModel {
    
    var discoverPosterController: DiscoverPosterController
    
    override init(frame: CGRect) {
        self.discoverPosterController = DiscoverPosterController()

        super.init(frame: frame)

        setupView()
        setupUIElements()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var viewModel: DiscoverPosterViewModel!
    var bindedViewModel: ViewModelType!
    func bindViewModel() {
        discoverPosterController.bind(viewModel: bindedViewModel)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        discoverPosterController.disposeBag = DisposeBag()
    }
}

//MARK:- UI Elements
extension DiscoverCell {
    private func setupView() {
        backgroundColor = .systemBackground
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
