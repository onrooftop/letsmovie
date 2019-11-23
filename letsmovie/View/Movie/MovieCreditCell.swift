//
//  CreditCell.swift
//  letsmovie
//
//  Created by Panupong Kukutapan on 22/11/2562 BE.
//  Copyright © 2562 Panupong Kukutapan. All rights reserved.
//

import UIKit

class MovieCreditCell: UICollectionViewCell, UsableViewModel {
    
    var profileImageView = MovieCreditCell.profileImageView()
    var castNameLabel = MovieCreditCell.castNameLabel()
    var castCharacterLabel = MovieCreditCell.caseCharacterLabel()
    var padding: UIEdgeInsets = .init(top: 0, left: 12, bottom: 0, right: -12)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var viewModel: MovieCastViewModel!
    var bindedViewModel: ViewModelType!
    func bindViewModel() {
        viewModel = (bindedViewModel as? MovieCastViewModel)
    }
}

//MARK:- UI Elements
extension MovieCreditCell {
    private func setupView() {
        backgroundColor = .white
        
        let profileImageSize: CGFloat = self.frame.height
        profileImageView.layer.cornerRadius = profileImageSize / 2
        addSubview(profileImageView)
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            profileImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            profileImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding.left),
            profileImageView.widthAnchor.constraint(equalToConstant: profileImageSize),
            profileImageView.heightAnchor.constraint(equalToConstant: profileImageSize)
        ])
        
        let verticalStackView = UIStackView(arrangedSubviews: [UIView(), castNameLabel, castCharacterLabel, UIView()])
        verticalStackView.axis = .vertical
        verticalStackView.distribution = .equalCentering
        verticalStackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(verticalStackView)
        NSLayoutConstraint.activate([
            verticalStackView.topAnchor.constraint(equalTo: topAnchor),
            verticalStackView.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: padding.left),
            verticalStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: padding.right),
            verticalStackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        //TODO: Remove this when we have viewModel
        castNameLabel.text = "Joaquin Phoenix"
        setupCaseCharacterLabel(characterString: "Arthur Fleck / Joker")
    }
    
    class func profileImageView() -> UIImageView {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.backgroundColor = .lightGray
        return iv
    }
    
    class func castNameLabel() -> UILabel {
        let lb = UILabel()
        lb.font = .boldSystemFont(ofSize: 18)
        return lb
    }
    
    class func caseCharacterLabel() -> UILabel {
        let lb = UILabel()
        return lb
    }
    
    func setupCaseCharacterLabel(characterString: String) {
        let attributeText = NSMutableAttributedString(string: "as ", attributes: [.font: UIFont.systemFont(ofSize: 14), .foregroundColor: UIColor.lightGray])
        attributeText.append(NSAttributedString(string: characterString, attributes: [.font: UIFont.boldSystemFont(ofSize: 16), .foregroundColor: UIColor.darkGray]))
        castCharacterLabel.attributedText = attributeText
    }
}
