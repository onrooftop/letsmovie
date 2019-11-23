//
//  MovieGenresController.swift
//  letsmovie
//
//  Created by Panupong Kukutapan on 21/11/2562 BE.
//  Copyright © 2562 Panupong Kukutapan. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class MovieGenresController: UICollectionViewController, UsableViewModel {

    private let cellId = "cellId"
    private let minimumLineSpacing: CGFloat = 10
    private let contentInset: UIEdgeInsets = .init(top: 0, left: 10, bottom: 0, right: 10)
    private let cellPadding: UIEdgeInsets = .init(top: 0, left: 12, bottom: 0, right: 12)
    private let disposeBag = DisposeBag()
    
    var genres: [String] = []
    
    init() {
        let layout = UICollectionViewFlowLayout()
        super.init(collectionViewLayout: layout)
        layout.scrollDirection = .horizontal
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        setupCollectionView()
    }
    
    var viewModel: MovieGenreViewModel!
    var bindedViewModel: ViewModelType!
    func bindViewModel() {
        viewModel = (bindedViewModel as? MovieGenreViewModel)
        
        collectionView.delegate = nil
        collectionView.dataSource = nil
        
        viewModel.genres
            .subscribe(onNext: { [unowned self] (genres) in
                self.genres = genres
            })
            .disposed(by: disposeBag)
        
        viewModel.genres
            .bind(to: collectionView.rx.items(cellIdentifier: cellId, cellType: MovieGenreCell.self)) {(item, genre, cell) in
                cell.genreLabel.text = genre
            }
            .disposed(by: disposeBag)

        collectionView.rx
            .setDelegate(self)
            .disposed(by: disposeBag)
    }
}

//MARK: UI Elements
extension MovieGenresController {
    private func setupView() {
        collectionView.backgroundColor = .white
        collectionView.showsHorizontalScrollIndicator = false
    }
}

//MARK: CollectionView Dalegate
extension MovieGenresController: UICollectionViewDelegateFlowLayout {
    private func setupCollectionView() {
        collectionView.register(MovieGenreCell.self, forCellWithReuseIdentifier: cellId)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return minimumLineSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        let height = view.frame.height
        let dummySize = CGSize(width: 100, height: 100)
        let dummyCell = MovieGenreCell()
        dummyCell.genreLabel.text = genres[indexPath.item]
        dummyCell.layoutIfNeeded()
        let estimateCell = dummyCell.systemLayoutSizeFitting(dummySize)
        let width = estimateCell.width + cellPadding.right + cellPadding.left
        return .init(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return contentInset
    }
    
    
}
