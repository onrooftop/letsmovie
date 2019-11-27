//
//  PosterCell.swift
//  letsmovie
//
//  Created by Panupong Kukutapan on 14/11/2562 BE.
//  Copyright © 2562 Panupong Kukutapan. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Kingfisher

class PosterCell: UICollectionViewCell, UsableViewModel {
    
    var posterImageView = PosterCell.posterImageView()
    private let disposeBag = DisposeBag()
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var viewModel: PosterViewModel!
    var bindedViewModel: ViewModelType!
    func bindViewModel() {
        viewModel = (bindedViewModel as? PosterViewModel)
        
        viewModel.urlString
            .subscribe(onNext: { [unowned self] (urlString) in
                guard let url = ApiManager.posterImageUrl(posterPath: urlString, posterSize: .w342) else { return }
                self.posterImageView.kf.setImage(with: url)
            })
            .disposed(by: disposeBag)
    }
}

//MARK:- UI Elements
extension PosterCell {
    private func setupView() {
        addSubview(posterImageView)
        posterImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            posterImageView.topAnchor.constraint(equalTo: topAnchor),
            posterImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            posterImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            posterImageView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    class func posterImageView() -> UIImageView {
        let iv = UIImageView()
        iv.backgroundColor = .lightGray
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 2
        return iv
    }
}
