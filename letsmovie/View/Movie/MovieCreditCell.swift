//
//  CreditCell.swift
//  letsmovie
//
//  Created by Panupong Kukutapan on 22/11/2562 BE.
//  Copyright © 2562 Panupong Kukutapan. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Kingfisher

class MovieCreditCell: UICollectionViewCell, UsableViewModel {
    
    var shortNameLabel = MovieCreditCell.shortNameLabel()
    var profileImageView = MovieCreditCell.profileImageView()
    var nameLabel = MovieCreditCell.nameLabel()
    var detailLabel = MovieCreditCell.detailLabel()
    var padding: UIEdgeInsets = .init(top: 0, left: 12, bottom: 0, right: -12)
    
    private let disposeBag = DisposeBag()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var viewModel: MovieCreditViewModel!
    var bindedViewModel: ViewModelType!
    func bindViewModel() {
        viewModel = (bindedViewModel as? MovieCreditViewModel)
        
        viewModel.name
            .bind(to: nameLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.detail
            .bind(to: detailLabel.rx.attributedText)
            .disposed(by: disposeBag)
        
        viewModel.imagePath
            .subscribe(onNext: { [unowned self] (urlString) in
                guard let url = ApiManager.profileImageUrl(profilePath: urlString) else { return }
                self.profileImageView.kf.setImage(with: url)
            })
            .disposed(by: disposeBag)
        
        viewModel.shortName
            .bind(to: shortNameLabel.rx.text)
            .disposed(by: disposeBag)
    }
}

//MARK:- UI Elements
extension MovieCreditCell {
    private func setupView() {
        backgroundColor = .white
        
        shortNameLabel.translatesAutoresizingMaskIntoConstraints = false
        profileImageView.addSubview(shortNameLabel)
        NSLayoutConstraint.activate([
            shortNameLabel.centerXAnchor.constraint(equalTo: profileImageView.centerXAnchor),
            shortNameLabel.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor)
        ])
        
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
        
        let verticalStackView = UIStackView(arrangedSubviews: [UIView(), nameLabel, detailLabel, UIView()])
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
    }
    
    class func profileImageView() -> UIImageView {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.backgroundColor = .lightGray
        return iv
    }
    
    class func shortNameLabel() -> UILabel {
        let lb = UILabel()
        lb.font = .boldSystemFont(ofSize: 30)
        return lb
    }
    
    class func nameLabel() -> UILabel {
        let lb = UILabel()
        lb.font = .boldSystemFont(ofSize: 18)
        return lb
    }
    
    class func detailLabel() -> UILabel {
        let lb = UILabel()
        return lb
    }
}
