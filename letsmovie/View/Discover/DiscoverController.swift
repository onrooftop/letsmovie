//
//  DiscoverController.swift
//  letsmovie
//
//  Created by Panupong Kukutapan on 13/11/2562 BE.
//  Copyright © 2562 Panupong Kukutapan. All rights reserved.
//

import UIKit
import RxDataSources
import RxCocoa
import RxSwift
import Action

class DiscoverController: UICollectionViewController, UsableViewModel {
    
    private let cellId = "cellId"
    private let headerId = "headerId"
    
    private let disposeBag = DisposeBag()
    
    var dataSource: RxCollectionViewSectionedReloadDataSource<SectionViewModel>!
    
    init() {
        let layout = UICollectionViewFlowLayout()
        super.init(collectionViewLayout: layout)
        layout.scrollDirection = .vertical
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
    
    var bindedViewModel: ViewModelType!
    var viewModel: DiscoverViewModel!
    
    func bindViewModel() {
        viewModel = (bindedViewModel as! DiscoverViewModel)
        
        collectionView.dataSource = nil
        collectionView.delegate = nil
        
        dataSource = createDataSource()

        viewModel.sectionViewModels
            .bind(to: collectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        viewModel.movieViewModel
            .subscribe(onNext: { [unowned self] (movieViewModel) in
                var movieVC = MovieController()
                movieVC.hidesBottomBarWhenPushed = true
                movieVC.bind(viewModel: movieViewModel)
                self.navigationController?.pushViewController(movieVC, animated: true)
            })
            .disposed(by: disposeBag)
        
        viewModel.seeAllViewModel
            .subscribe(onNext: { [unowned self] (dicoverPosterViewModel) in
                var seeAllVC = DiscoverSeeAllController()
                seeAllVC.bind(viewModel: dicoverPosterViewModel)
                self.navigationController?.pushViewController(seeAllVC, animated: true)
            })
            .disposed(by: disposeBag)
        
        collectionView.rx
            .setDelegate(self)
            .disposed(by: disposeBag)

    }

}


//MARK:- UI Elements
extension DiscoverController {
    private func setupView() {
        collectionView.backgroundColor = .white
    }
    
    private func setupNavigationController() {
        navigationItem.largeTitleDisplayMode = .always
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "Discover"
    }
}

//MARK:- RxDatasources
extension DiscoverController {
    func createDataSource() -> RxCollectionViewSectionedReloadDataSource<SectionViewModel> {
        let dataSource = RxCollectionViewSectionedReloadDataSource<SectionViewModel>( configureCell: { (dataSource, collectionView, indexPath, viewModel) -> UICollectionViewCell in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DiscoverPosterViewModel.cellIdentifier, for: indexPath)
            if var cell = cell as? ViewModelBindableType {
                cell.bind(viewModel: viewModel)
            }
            return cell
        })
        
        dataSource.configureSupplementaryView = { (dataSource, collectionView, kind, indexPath) -> UICollectionReusableView in
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: DiscoverHeaderViewModel.cellIdentifier, for: indexPath)
            let viewModel = dataSource.sectionModels[indexPath.section].header!
            if var header = header as? ViewModelBindableType {
                header.bind(viewModel: viewModel)
            }
            return header
        }
        
        return dataSource
    }
}

//MARK:- CollectionView Delegate and Datasource
extension DiscoverController: UICollectionViewDelegateFlowLayout {
    private func setupCollectionView() {
        collectionView.register(DiscoverCell.self, forCellWithReuseIdentifier: DiscoverPosterViewModel.cellIdentifier)
        collectionView.register(DiscoverHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: DiscoverHeaderViewModel.cellIdentifier)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let height: CGFloat = 50
        let width: CGFloat = view.frame.width
        return .init(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height: CGFloat = 400
        let width: CGFloat = view.frame.width
        return .init(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 0, left: 0, bottom: 10, right: 0)
    }
}
