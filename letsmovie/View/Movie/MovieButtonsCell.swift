//
//  MovieButtonsCell.swift
//  letsmovie
//
//  Created by Panupong Kukutapan on 21/11/2562 BE.
//  Copyright © 2562 Panupong Kukutapan. All rights reserved.
//

import UIKit

class MovieButtonsCell: UICollectionViewCell {
    
    var horizontalStackView = MovieButtonsCell.horizontalStackView()
    var watchlistButton = MovieButtonsCell.createButton(title: "Watchlist")
    var watchedButton = MovieButtonsCell.createButton(title: "Watched")
    
    private let buttonSpacing: CGFloat = 12
    private lazy var stackViewPadding: UIEdgeInsets = {
        return .init(top: self.buttonSpacing, left: self.buttonSpacing / 2, bottom: -self.buttonSpacing, right: -self.buttonSpacing / 2)
    }()
    
    private let buttonHeight: CGFloat = 40
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

//MARK: UI Elements
extension MovieButtonsCell {
    private func setupView() {
        backgroundColor = .white
        
        watchlistButton.translatesAutoresizingMaskIntoConstraints = false
        watchedButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            watchlistButton.heightAnchor.constraint(equalToConstant: buttonHeight),
            watchedButton.heightAnchor.constraint(equalToConstant: buttonHeight),
        ])
        watchlistButton.layer.cornerRadius = buttonHeight / 2
        watchedButton.layer.cornerRadius = buttonHeight / 2
        horizontalStackView.addArrangedSubview(watchlistButton)
        horizontalStackView.addArrangedSubview(watchedButton)
        horizontalStackView.translatesAutoresizingMaskIntoConstraints = false
        horizontalStackView.spacing = buttonSpacing
        addSubview(horizontalStackView)
        NSLayoutConstraint.activate([
            horizontalStackView.topAnchor.constraint(equalTo: topAnchor, constant: stackViewPadding.top),
            horizontalStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: stackViewPadding.left),
            horizontalStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: stackViewPadding.right),
        ])
        
    }
    
    class func createButton(title: String) -> UIButton {
        let bt = UIButton(type: UIButton.ButtonType.system)
        bt.setTitle(title, for: .normal)
        bt.layer.borderColor = UIColor.black.cgColor
        bt.layer.borderWidth = 2
        bt.backgroundColor = .clear
        bt.setTitleColor(.black, for: .normal)
        bt.setTitleColor(.white, for: .highlighted)
        bt.titleLabel?.font = .boldSystemFont(ofSize: 18)
        bt.clipsToBounds = true
        return bt
    }
    
    class func horizontalStackView() -> UIStackView {
        let sv = UIStackView()
        sv.axis = .horizontal
        sv.distribution = .fillEqually
        return sv
    }
}
