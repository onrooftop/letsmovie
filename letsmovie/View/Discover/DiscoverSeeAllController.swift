//
//  DiscoverSeeAllController.swift
//  letsmovie
//
//  Created by Panupong Kukutapan on 19/11/2562 BE.
//  Copyright © 2562 Panupong Kukutapan. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Kingfisher
import RxDataSources

class DiscoverSeeAllController: UICollectionViewController, ViewModelBindableType {
    
    private let cellId = "cellId"
    private let footerId = "footId"
    private let paddingInset: UIEdgeInsets = .init(top: 10, left: 10, bottom: 10, right: 10)
    private let padding: CGFloat = 10
    var viewModel: DiscoverPosterViewModel!
    let disposeBag = DisposeBag()
    
    init() {
        let layout = UICollectionViewFlowLayout()
        super.init(collectionViewLayout: layout)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        setupNavigationController()
        setupCollectionView()
    }
    
    func bindViewModel() {
        viewModel.title
            .bind(to: navigationItem.rx.title)
            .disposed(by: disposeBag)
        
        collectionView.delegate = nil
        collectionView.dataSource = nil
        
        let dataSource = createDataSource()
        
        viewModel.sections
            .bind(to: collectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        collectionView.rx
            .setDelegate(self)
            .disposed(by: disposeBag)
        
        guard let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else { return }
        
        self.viewModel.cannotLoadMore
            .subscribe(onNext: { (isHidden) in
                if isHidden {
                    layout.footerReferenceSize = .zero
                } else {
                    layout.footerReferenceSize = .init(width: self.view.frame.width, height: 50)
                }
            })
            .disposed(by: disposeBag)
        
    }
}

//MARK:- UI Elements
extension DiscoverSeeAllController {
    func setupView() {
        collectionView.backgroundColor = .white
    }
    
    func setupNavigationController() {
        navigationItem.setHidesBackButton(true, animated: true)
    }
}

//MARK:- RxDataSource
extension DiscoverSeeAllController {
    func createDataSource() -> RxCollectionViewSectionedReloadDataSource<DiscoverPosterSection> {
        let dataSource = RxCollectionViewSectionedReloadDataSource<DiscoverPosterSection>( configureCell: { (dataSource, collectionView, indexPath, item) -> UICollectionViewCell in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.cellId, for: indexPath) as! PosterCell
            if let url = ApiManager.shared.posterImageUrl(posterPath: item.posterPath) {
                cell.posterImageView.kf.setImage(with: url)
            }
            return cell
        })
        
        dataSource.configureSupplementaryView = { (dataSource, collectionView, kind, indexPath) -> UICollectionReusableView in
            let footer = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: self.footerId, for: indexPath) as! SeeAllFooter
            self.viewModel.loadMoreData.onNext(())
            
            return footer
        }
        
        return dataSource
    }
}

//MARK:- CollectionView Delegate
extension DiscoverSeeAllController: UICollectionViewDelegateFlowLayout {
    private func setupCollectionView() {
        collectionView.register(PosterCell.self, forCellWithReuseIdentifier: cellId)
        collectionView.register(SeeAllFooter.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: footerId)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let assumedRatio: CGFloat = 3 / 2
        let numberOfItemsInRow = 3
        let width = floor((view.frame.width - (padding * CGFloat(numberOfItemsInRow - 1)) - paddingInset.left - paddingInset.right) / CGFloat(numberOfItemsInRow))
        let height = assumedRatio * width
        return .init(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return padding
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return padding
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return paddingInset
    }
}
