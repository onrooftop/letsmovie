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
    private let minimumLineSpacing: CGFloat = 10
    private let disposeBag = DisposeBag()
    
    init() {
        let layout = StretchyHeaderFlowLayout()
        super.init(collectionViewLayout: layout)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupNavigationController()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
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
            
        case is MovieCreditViewModel:
            return MovieCreditViewModel.cellIdentifier
            
        case is MovieButtonsViewModel:
            return MovieButtonsViewModel.cellIdentifier
            
        default:
            return ""
        }
    }
}

//MARK:- CollectionView Delegate DataSource
extension MovieController: UICollectionViewDelegateFlowLayout {
    private func setupCollectionView() {
        
        collectionView.register(MovieHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: MovieHeaderViewModel.cellIdentifier)
        
        collectionView.register(MovieButtonsCell.self, forCellWithReuseIdentifier: MovieButtonsViewModel.cellIdentifier)

        collectionView.register(MovieGenresCell.self, forCellWithReuseIdentifier: MovieGenreViewModel.cellIdentifier)
        
        collectionView.register(MovieOverviewCell.self, forCellWithReuseIdentifier: MovieOverviewViewModel.cellIdentifier)
        
        collectionView.register(MovieCreditHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: MovieCreditHeaderViewModel.cellIdentifier)
        
        collectionView.register(MovieCreditCell.self, forCellWithReuseIdentifier: MovieCreditViewModel.cellIdentifier)
}

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let headerViewModel = viewModel.sectionsArray[section].header
        return getHeaderSize(from: headerViewModel)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellViewModel = viewModel.sectionsArray[indexPath.section].items[indexPath.item]
        return getCellSize(from: cellViewModel)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return minimumLineSpacing
    }
    
}

//MARK:- Size for cell
extension MovieController {
    
    func getHeaderSize(from viewModel: ViewModelType) -> CGSize {
        var height: CGFloat = 0
        
        switch viewModel {
        case is MovieHeaderViewModel:
            height = 400
            
        case is MovieCreditHeaderViewModel:
            height = 50
            
        default:
            height = 0
        }
        
        return .init(width: view.frame.width, height: height)
    }
    
    func getCellSize(from viewModel: ViewModelType) -> CGSize {
        
        var height: CGFloat = 0
        
        switch viewModel {

        case is MovieButtonsViewModel:
            height = 54
            
        case is MovieGenreViewModel:
            height =  42
            
        case is MovieOverviewViewModel:
            var dummyCell = MovieOverviewCell()
            dummyCell.bind(viewModel: viewModel)
            let width = view.frame.width - dummyCell.padding.left - dummyCell.padding.right
            height = dummyCell.overviewLabel.height(width: width) + dummyCell.overviewTitleLabel.height(width: width)
            
        case is MovieCreditViewModel:
            height = 64
            
        default:
            height = 0
        }
        
        return .init(width: view.frame.width, height: height)
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
