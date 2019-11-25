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

class DiscoverPosterController: UICollectionViewController, UsableViewModel {
    
    private let disposeBag = DisposeBag()
    
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
    
        collectionView.rx
            .setDelegate(self)
            .disposed(by: disposeBag)
        
        collectionView.rx.itemSelected
            .bind(to: viewModel.movieAction.inputs)
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
    func createDataSource() -> RxCollectionViewSectionedReloadDataSource<SectionViewModel> {
        let dataSource = RxCollectionViewSectionedReloadDataSource<SectionViewModel>( configureCell: { (dataSource, collectionView, indexPath, viewModel) -> UICollectionViewCell in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PosterViewModel.cellIdentifier, for: indexPath)
            
            if var cell = cell as? ViewModelBindableType {
                cell.bind(viewModel: viewModel)
            }
            
            return cell
        })
        return dataSource
    }
}

//MARK:- CollectionView Delegate and Datasource
extension DiscoverPosterController: UICollectionViewDelegateFlowLayout {
    private func setupCollectionView() {
        collectionView.register(PosterCell.self, forCellWithReuseIdentifier: PosterViewModel.cellIdentifier)
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
