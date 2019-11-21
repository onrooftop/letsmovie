//
//  MovieController.swift
//  letsmovie
//
//  Created by Panupong Kukutapan on 20/11/2562 BE.
//  Copyright © 2562 Panupong Kukutapan. All rights reserved.
//

import UIKit

class MovieController: UICollectionViewController {
    
    private let cellId = "cellId"
    private let headerId = "headerId"
    private let buttonsCellId = "buttonsCellId"
    private let genresCellId = "genresCellId"
    private let spacingHeaderId = "spacingHeaderId"
    
    private let minimumLineSpacing: CGFloat = 10
    
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

//MARK:- CollectionView Delegate DataSource
extension MovieController: UICollectionViewDelegateFlowLayout {
    private func setupCollectionView() {
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: cellId)
        collectionView.register(MovieHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerId)
        collectionView.register(MovieButtonsCell.self, forCellWithReuseIdentifier: buttonsCellId)
        collectionView.register(MovieGenresCell.self, forCellWithReuseIdentifier: genresCellId)
        collectionView.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: spacingHeaderId)
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch indexPath.section {
        case 0:
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerId, for: indexPath) as! MovieHeader
          return header
        default:
            let spacingHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: spacingHeaderId, for: indexPath)
            spacingHeader.backgroundColor = .clear
            return spacingHeader
        }
      
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case 0:
            switch indexPath.item {
            case 0:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: buttonsCellId, for: indexPath) as! MovieButtonsCell
                return cell
            case 1:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: genresCellId, for: indexPath)
                return cell
            default:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath)
                cell.backgroundColor = .red
                return cell
            }
        default:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath)
            cell.backgroundColor = .red
            return cell
        }
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        var numberOfItems = 40
        switch section {
        case 0:
            numberOfItems = 2
        default:
            numberOfItems = 40
        }
        
        return numberOfItems
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        var height: CGFloat = minimumLineSpacing
        switch section {
        case 0:
            height = 400
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
            default:
                height = 50
            }
        default:
            height = 10
        }
        
        return .init(width: view.frame.width, height: height)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return minimumLineSpacing
    }
}
