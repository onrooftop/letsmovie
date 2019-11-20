//
//  MovieHeader.swift
//  letsmovie
//
//  Created by Panupong Kukutapan on 20/11/2562 BE.
//  Copyright © 2562 Panupong Kukutapan. All rights reserved.
//

import UIKit

class MovieHeader: UICollectionReusableView {
    
    var backdropImageView = MovieHeader.backdropImageView()
    var gradientLayer = MovieHeader.gradientLayer()
    var titleLabel = MovieHeader.titleLabel()
    var runtimeLabel = MovieHeader.runtimeLabel()
    
    private var labelPadding: UIEdgeInsets = .init(top: 0, left: 24, bottom: -24, right: -24)
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK:- UI Elements
extension MovieHeader {
    private func setupView() {
        backgroundColor = .black
        
        addSubview(backdropImageView)
        backdropImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            backdropImageView.topAnchor.constraint(equalTo: topAnchor),
            backdropImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            backdropImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            backdropImageView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        let contrainnerGradient = UIView()
        contrainnerGradient.layer.addSublayer(gradientLayer)
        gradientLayer.frame = self.bounds
        gradientLayer.frame.origin.y -= self.bounds.height
        addSubview(contrainnerGradient)
        contrainnerGradient.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            contrainnerGradient.leadingAnchor.constraint(equalTo: leadingAnchor),
            contrainnerGradient.trailingAnchor.constraint(equalTo: trailingAnchor),
            contrainnerGradient.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        let verticalStackView = UIStackView(arrangedSubviews: [titleLabel, runtimeLabel])
        verticalStackView.axis = .vertical
        verticalStackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(verticalStackView)
        NSLayoutConstraint.activate([
            verticalStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: labelPadding.left),
            verticalStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: labelPadding.right),
            verticalStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: labelPadding.bottom)
        ])
    }
    
    class func backdropImageView() -> UIImageView {
        let iv = UIImageView()
        //TODO: remove this when finished viewModel
        iv.image = #imageLiteral(resourceName: "backdrop")
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.alpha = 0.6
        return iv
    }
    
    class func gradientLayer() -> CAGradientLayer {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [ UIColor.clear.cgColor, UIColor.black.cgColor ]
        gradientLayer.locations = [ 0   , 1 ]
        return gradientLayer
    }
    
    class func titleLabel() -> UILabel {
        let lb = UILabel()
        lb.font = .boldSystemFont(ofSize: 64)
        lb.numberOfLines = 2
        lb.lineBreakMode = .byWordWrapping
        lb.textColor = .white
        lb.text = "Joker"
        return lb
    }
    
    class func runtimeLabel() -> UILabel {
        let lb = UILabel()
        lb.font = .systemFont(ofSize: 24)
        lb.textColor = .white
        lb.text = "120 min"
        return lb
    }
}
