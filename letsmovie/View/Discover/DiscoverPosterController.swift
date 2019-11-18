//
//  DiscoverPosterController.swift
//  letsmovie
//
//  Created by Panupong Kukutapan on 14/11/2562 BE.
//  Copyright © 2562 Panupong Kukutapan. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources
import Kingfisher

class DiscoverPosterController: UICollectionViewController, ViewModelBindableType{
    
    private let cellId = "cellId"
    private let disposeBag = DisposeBag()
    var viewModel: DiscoverPosterViewModel!
    
//    var dataSource
    
    init() {
        let layout = SnappingHorizontalFlowLayout()
        super.init(collectionViewLayout: layout)
        layout.scrollDirection = .horizontal
        collectionView.decelerationRate = .fast
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        setupCollectionView()
    }
    
    func bindViewModel() {
        collectionView.delegate = nil
        collectionView.dataSource = nil
        
        viewModel.posters
            .bind(to: collectionView.rx.items(cellIdentifier: self.cellId, cellType: PosterCell.self)) {
                (row, data, cell) in
                guard let url = ApiManager.shared.posterImageUrl(posterPath: data.posterPath) else { return }
                cell.posterImageView.kf.setImage(with: url)
            }
            .disposed(by: disposeBag)
        
        collectionView.rx
            .setDelegate(self)
            .disposed(by: disposeBag)
    }
}

//MARK:- UI Elements
extension DiscoverPosterController {
    private func setupView() {
        collectionView.backgroundColor = .white
    }
}

//MARK:- CollectionView Delegate and Datasource
extension DiscoverPosterController: UICollectionViewDelegateFlowLayout {
    private func setupCollectionView() {
        collectionView.register(PosterCell.self, forCellWithReuseIdentifier: cellId)
        collectionView.contentInset = .init(top: 0, left: 10, bottom: 0, right: 100)
        collectionView.showsHorizontalScrollIndicator = false
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let assumedRatio: CGFloat = 4 / 3
        let height: CGFloat = view.frame.height
        let width: CGFloat = height * 1 / assumedRatio
        return .init(width: width, height: height)
    }
}
