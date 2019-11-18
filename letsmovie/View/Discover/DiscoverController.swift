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

class DiscoverController: UICollectionViewController, ViewModelBindableType {

    private static let cellId = "cellId"
    private static let headerId = "headerId"
    
    private let disposeBag = DisposeBag()
    
    var viewModel: DiscoverViewModel!
    var dataSource: RxCollectionViewSectionedReloadDataSource<DiscoverSection>!
    
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
    
    func bindViewModel() {
        
        collectionView.dataSource = nil
        collectionView.delegate = nil
        
        dataSource = DiscoverController.dataSource()

        viewModel.discoverSections
            .bind(to: collectionView.rx.items(dataSource: dataSource))
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
    static func dataSource() -> RxCollectionViewSectionedReloadDataSource<DiscoverSection> {
        let dataSource = RxCollectionViewSectionedReloadDataSource<DiscoverSection>( configureCell: { (dataSource, collectionView, indexPath, item) -> UICollectionViewCell in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.cellId, for: indexPath) as! DiscoverCell
            cell.discoverType = item
            return cell
        })

        dataSource.configureSupplementaryView = { (dataSource, collectionView, kind, indexPath) -> UICollectionReusableView in
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: self.headerId, for: indexPath) as! DiscoverHeader
            let headerTitle = dataSource.sectionModels[indexPath.section].header
            header.titleLabel.text = headerTitle
            return header
        }
        
        return dataSource
    }
}

//MARK:- CollectionView Delegate and Datasource
extension DiscoverController: UICollectionViewDelegateFlowLayout {
    private func setupCollectionView() {
        collectionView.register(DiscoverCell.self, forCellWithReuseIdentifier: DiscoverController.cellId)
        collectionView.register(DiscoverHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: DiscoverController.headerId)
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
