//
//  CreditHeader.swift
//  letsmovie
//
//  Created by Panupong Kukutapan on 22/11/2562 BE.
//  Copyright © 2562 Panupong Kukutapan. All rights reserved.
//

import UIKit

class MovieCreditHeader: UICollectionReusableView, UsableViewModel {
    
    var titleLabel = MovieCreditHeader.titleLabel()
    var padding: UIEdgeInsets = .init(top: 0, left: 12, bottom: 0, right: -12)
    var bottomAnchorConstant: CGFloat = -10
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var viewModel: MovieCreditHeaderViewModel!
    var bindedViewModel: ViewModelType!
    func bindViewModel() {
        viewModel = (bindedViewModel as? MovieCreditHeaderViewModel)
    }
}

//MARK:- UI Elements
extension MovieCreditHeader {
    private func setupView() {
        backgroundColor = .white
        
        addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding.left),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: padding.right),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: bottomAnchorConstant)
        ])
    }
    
    class func titleLabel() -> UILabel {
        let lb = UILabel()
        lb.font = .boldSystemFont(ofSize: 20)
        return lb
    }
}
