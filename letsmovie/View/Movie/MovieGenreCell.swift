//
//  MovieGenreCell.swift
//  letsmovie
//
//  Created by Panupong Kukutapan on 21/11/2562 BE.
//  Copyright © 2562 Panupong Kukutapan. All rights reserved.
//

import UIKit

class MovieGenreCell: UICollectionViewCell {
    
    var genreLabel = MovieGenreCell.genreLabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK:- UI Elements
extension MovieGenreCell {
    private func setupView() {
        backgroundColor = .black
        
        let height = frame.height
        layer.cornerRadius = height / 2
        clipsToBounds = true
        
        genreLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(genreLabel)
        NSLayoutConstraint.activate([
            genreLabel.topAnchor.constraint(equalTo: topAnchor),
            genreLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            genreLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            genreLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    class func genreLabel() -> UILabel {
        let lb = UILabel()
        lb.font = .boldSystemFont(ofSize: 16)
        lb.textColor = .white
        //TODO: remove this when we have viewModel
        lb.text = "Science Fiction"
        lb.textAlignment = .center
        return lb
    }
}
