//
//  PageController.swift
//  letsmovie
//
//  Created by Panupong Kukutapan on 14/11/2562 BE.
//  Copyright © 2562 Panupong Kukutapan. All rights reserved.
//

import UIKit

class PosterController: UICollectionViewController {
    
    private let cellId = "cellId"
    
    private let posterSpacing: CGFloat = 10
    private let contentInset: UIEdgeInsets = .init(top: 10, left: 10, bottom: 10, right: 10)
    
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


//MARK:- CollectionView Delegate Datasource
extension PosterController: UICollectionViewDelegateFlowLayout {
    
    private func setupCollectionViewController() {
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: cellId)
        collectionView.contentInset = self.contentInset
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath)
        cell.backgroundColor = .red
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let assumedPosterRaito: CGFloat = 16 / 9
        let numberOfItemInRow: CGFloat = 3
        let totalPosterSpacing: CGFloat = posterSpacing * (numberOfItemInRow - 1) + contentInset.left + contentInset.right
        let width: CGFloat = floor((view.frame.width - totalPosterSpacing) / numberOfItemInRow)
        let height: CGFloat = width * assumedPosterRaito
        
        return .init(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return posterSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return posterSpacing
    }

}
