//
//  PosterController.swift
//  letsmovie
//
//  Created by Panupong Kukutapan on 14/11/2562 BE.
//  Copyright © 2562 Panupong Kukutapan. All rights reserved.
//

import UIKit

class PosterController: UICollectionViewController {
    
    private let cellId = "cellId"
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
    }
}

//MARK:- UI Elements
extension PosterController {
    private func setupView() {
        collectionView.backgroundColor = .white
    }
}

//MARK:- CollectionView Delegate and Datasource
extension PosterController: UICollectionViewDelegateFlowLayout {
    private func setupCollectionViewController() {
        collectionView.register(PosterCell.self, forCellWithReuseIdentifier: cellId)
        collectionView.contentInset = self.contentInset
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 14
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! PosterCell
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let assumedPosterRatio: CGFloat = 16 / 9
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
