//
//  PosterController.swift
//  letsmovie
//
//  Created by Panupong Kukutapan on 14/11/2562 BE.
//  Copyright © 2562 Panupong Kukutapan. All rights reserved.
//

import UIKit
import RxSwift
import RxDataSources

class MePageController: UICollectionViewController, UsableViewModel {
    private var noMoviesMessageLabel = MePageController.noMoviesInListLabel()
    
    var disposeBag = DisposeBag()
    private let contentInset: UIEdgeInsets = .init(top: 10, left: 10, bottom: 10, right: 10)
    private let posterSpacing: CGFloat = 10
    
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
        setupCollectionViewController()
        setupUIElements()
    }
    
    var viewModel: MePosterViewModel!
    var bindedViewModel: ViewModelType!
    func bindViewModel() {
        viewModel = (bindedViewModel as? MePosterViewModel)
        
        collectionView.delegate = nil
        collectionView.dataSource = nil
        
        viewModel.posterViewModels
            .bind(to: collectionView.rx.items(cellIdentifier: PosterViewModel.cellIdentifier, cellType: PosterCell.self)) {
                (item, viewModel, cell) in
                var posterCell = cell
                posterCell.bind(viewModel: viewModel)
            }
            .disposed(by: disposeBag)
        
        viewModel.isNoMovieMessageHidden
            .bind(to: noMoviesMessageLabel.rx.isHidden)
            .disposed(by: disposeBag)
        
        viewModel.noMovieMessage
            .bind(to: noMoviesMessageLabel.rx.text)
            .disposed(by: disposeBag)
        
        collectionView.rx.itemSelected
            .bind(to: viewModel.movieAction.inputs)
            .disposed(by: disposeBag)
        
        collectionView.rx
            .setDelegate(self)
            .disposed(by: disposeBag)

    }
}

//MARK:- UI Elements
extension MePageController {
    private func setupView() {
        collectionView.backgroundColor = .white
    }
}

//MARK:- CollectionView Delegate and Datasource
extension MePageController: UICollectionViewDelegateFlowLayout {
    private func setupCollectionViewController() {
        collectionView.register(PosterCell.self, forCellWithReuseIdentifier: PosterViewModel.cellIdentifier)
        collectionView.contentInset = self.contentInset
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let assumedPosterRatio: CGFloat = posterRatio
        let numberOfItemsInRow = 3
        let totalPosterSpacing = posterSpacing * CGFloat(numberOfItemsInRow - 1) + self.contentInset.left + self.contentInset.right
        let width: CGFloat = floor((view.frame.width - totalPosterSpacing) / CGFloat(numberOfItemsInRow))
        let height: CGFloat = width * assumedPosterRatio
        return .init(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return posterSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return posterSpacing
    }
}

//MARK:- UI Elements
extension MePageController {
    private func setupUIElements() {
        collectionView.addSubview(noMoviesMessageLabel)
        noMoviesMessageLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            noMoviesMessageLabel.centerYAnchor.constraint(equalTo: collectionView.centerYAnchor),
            noMoviesMessageLabel.centerXAnchor.constraint(equalTo: collectionView.centerXAnchor),
        ])
    }
    
    class func noMoviesInListLabel() -> UILabel {
        let lb = UILabel()
        lb.font = .systemFont(ofSize: 18)
        lb.textColor = .lightGray
        lb.numberOfLines = 0
        lb.textAlignment = .center
        return lb
    }
}
