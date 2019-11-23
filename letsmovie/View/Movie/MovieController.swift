//
//  MovieController.swift
//  letsmovie
//
//  Created by Panupong Kukutapan on 20/11/2562 BE.
//  Copyright © 2562 Panupong Kukutapan. All rights reserved.
//

import UIKit
import RxSwift
import RxDataSources
import RxCocoa

class MovieController: UICollectionViewController, UsableViewModel {
    private let buttonsCellId = "buttonsCellId"
    private let minimumLineSpacing: CGFloat = 10
    private let disposeBag = DisposeBag()
    
    init() {
        let layout = StretchyHeaderFlowLayout()
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

    var viewModel: MovieViewModel!
    var bindedViewModel: ViewModelType!
    func bindViewModel() {
        viewModel = (bindedViewModel as? MovieViewModel)
        
        collectionView.delegate = nil
        collectionView.dataSource = nil
        
        let dataSource = createDataSource()
        
        viewModel.sectionViewModels
            .bind(to: collectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        collectionView.rx
            .setDelegate(self)
            .disposed(by: disposeBag)
        
    }
}

//MARK:- UI Elements
extension MovieController {
    private func setupView() {
        collectionView.backgroundColor = .white
        collectionView.contentInsetAdjustmentBehavior = .never
        collectionView.showsVerticalScrollIndicator = false
    }
    
    private func setupNavigationController() {
        navigationController?.navigationBar.isHidden = true
    }
}

//MARK:- RxDataSoruce
extension MovieController {
    func createDataSource() -> RxCollectionViewSectionedReloadDataSource<SectionViewModel> {
        let dataSource = RxCollectionViewSectionedReloadDataSource<SectionViewModel>( configureCell: { (dataSource, collectionView, indexPath, viewModel) -> UICollectionViewCell in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.getIdentifier(from: viewModel), for: indexPath)
            if var cell = cell as? ViewModelBindableType {
                cell.bind(viewModel: viewModel)
            }
            return cell
        })
        
        dataSource.configureSupplementaryView = { (dataSource, collectionView, kind, indexPath) -> UICollectionReusableView in
            let viewModel = dataSource.sectionModels[indexPath.section].header
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: self.getIdentifier(from: viewModel), for: indexPath)
            if var header = header as? ViewModelBindableType {
                header.bind(viewModel: viewModel)
            }
            return header
        }
        
        return dataSource
    }
    
    func getIdentifier(from viewModel: ViewModelType) -> String {
        switch viewModel {
        case is MovieHeaderViewModel:
            return MovieHeaderViewModel.cellIdentifier
            
        case is MovieGenreViewModel:
            return MovieGenreViewModel.cellIdentifier
            
        case is MovieOverviewViewModel:
            return MovieOverviewViewModel.cellIdentifier
            
        case is MovieCreditHeaderViewModel:
            return MovieCreditHeaderViewModel.cellIdentifier
            
        case is MovieCastViewModel:
            return MovieCastViewModel.cellIdentifier
            
        default:
            return ""
        }
    }
}

//MARK:- CollectionView Delegate DataSource
extension MovieController: UICollectionViewDelegateFlowLayout {
    private func setupCollectionView() {
        
        collectionView.register(MovieHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: MovieHeaderViewModel.cellIdentifier)
        
        collectionView.register(MovieButtonsCell.self, forCellWithReuseIdentifier: buttonsCellId)

        collectionView.register(MovieGenresCell.self, forCellWithReuseIdentifier: MovieGenreViewModel.cellIdentifier)
        
        collectionView.register(MovieOverviewCell.self, forCellWithReuseIdentifier: MovieOverviewViewModel.cellIdentifier)
        
        collectionView.register(MovieCreditHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: MovieCreditHeaderViewModel.cellIdentifier)
        
        collectionView.register(MovieCreditCell.self, forCellWithReuseIdentifier: MovieCastViewModel.cellIdentifier)
}
    
//    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
//        switch indexPath.section {
//        case 0:
//            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerId, for: indexPath) as! MovieHeaderView
//          return header
//        case 1:
//            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: creditHeaderId, for: indexPath) as! MovieCreditHeader
//            header.titleLabel.text = "Cast"
//            return header
//        default:
//            let spacingHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: spacingHeaderId, for: indexPath)
//            spacingHeader.backgroundColor = .clear
//            return spacingHeader
//        }
//
//    }
    
//    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        switch indexPath.section {
//        case 0:
//            switch indexPath.item {
//            case 0:
//                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: buttonsCellId, for: indexPath) as! MovieButtonsCell
//                return cell
//            case 1:
//                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: genresCellId, for: indexPath)
//                return cell
//            case 2:
//                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: overviewCellId, for: indexPath) as! MovieOverviewCell
//                cell.overviewLabel.text = overviewText
//                return cell
//            default:
//                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath)
//                cell.backgroundColor = .red
//                return cell
//            }
//        default:
//            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: creditCellId, for: indexPath) as! MovieCreditCell
//
//            return cell
//        }
//    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        var height: CGFloat = minimumLineSpacing
        switch section {
        case 0:
            height = 400
        case 1:
            height = 50
        default:
            height = minimumLineSpacing
        }
        
        return .init(width: view.frame.width, height: height)
    }
   
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        var height: CGFloat = 50
        switch indexPath.section {
        case 0:
            switch indexPath.item {
            case 0:
                height = 54
            case 1:
                height = 42
            case 2:
                let dummyCell = MovieOverviewCell()
//                dummyCell.overviewLabel.text = overviewText
                let width = view.frame.width - dummyCell.padding.left - dummyCell.padding.right
                height = dummyCell.overviewLabel.height(width: width) + dummyCell.overviewTitleLabel.height(width: width)
            default:
                height = 50
            }
        default:
            height = 64
        }
        
        return .init(width: view.frame.width, height: height)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return minimumLineSpacing
    }
    
}

extension String {
    func height(width: CGFloat, font: UIFont) -> CGFloat {
        let dummySize = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingRect = self.boundingRect(with: dummySize, options: .usesLineFragmentOrigin, attributes: [.font: font], context: nil)
        return boundingRect.height
    }
}


extension UILabel {
    func height(width: CGFloat) -> CGFloat {
        if let text = self.text {
            return text.height(width: width, font: self.font)
        }
        
        return 0
    }
}
