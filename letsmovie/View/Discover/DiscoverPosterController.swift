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

protocol PosterDelegate: class {
    func didSelectItem(with id: Int)
}

class DiscoverPosterController: UICollectionViewController, UsableViewModel {
    
    private let cellId = "cellId"
    private let disposeBag = DisposeBag()
    weak var delegate: PosterDelegate?
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
    
    var viewModel: DiscoverPosterViewModel!
    var bindedViewModel: ViewModelType!
    func bindViewModel() {
        viewModel = (bindedViewModel as? DiscoverPosterViewModel)
        
        collectionView.delegate = nil
        collectionView.dataSource = nil
        
        let dataSource = createDataSource()
        
        viewModel.sections
            .bind(to: collectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        viewModel.selectedId
            .subscribe(onNext: { (id) in
                self.delegate?.didSelectItem(with: id)
            })
            .disposed(by: disposeBag)
        
        collectionView.rx
            .setDelegate(self)
            .disposed(by: disposeBag)
        
        collectionView.rx.itemSelected
            .bind(to: viewModel.selectedItem)
            .disposed(by: disposeBag)
    }
}

//MARK:- UI Elements
extension DiscoverPosterController {
    private func setupView() {
        collectionView.backgroundColor = .white
    }
}

//MARK:- RxDataSource
extension DiscoverPosterController {
    func createDataSource() -> RxCollectionViewSectionedReloadDataSource<DiscoverPosterSection> {
        let dataSource = RxCollectionViewSectionedReloadDataSource<DiscoverPosterSection>( configureCell: { (dataSource, collectionView, indexPath, item) -> UICollectionViewCell in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.cellId, for: indexPath) as! PosterCell
            if let url = ApiManager.posterImageUrl(posterPath: item.posterPath) {
                cell.posterImageView.kf.setImage(with: url)
            }
            return cell
        })
        return dataSource
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
        let assumedRatio: CGFloat = 3 / 2
        let height: CGFloat = view.frame.height
        let width: CGFloat = height * 1 / assumedRatio
        return .init(width: width, height: height)
    }
}
