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
    private let creditHeaderId = "creditHeaderId"
    private let buttonsCellId = "buttonsCellId"
    private let genresCellId = "genresCellId"
    private let overviewCellId = "overviewCellId"
    private let creditCellId = "creditCellId"
    private let spacingHeaderId = "spacingHeaderId"
    
    private let minimumLineSpacing: CGFloat = 10
    
    //TODO: Remove this when finished viewModel
    private let overviewText = "Elsa, Anna, Kristoff and Olaf are going far in the forest to know the truth about an ancient mystery of their kingdom."
    
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
        
        collectionView.register(MovieCreditHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: creditHeaderId)
        
        collectionView.register(MovieHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerId)
        
        collectionView.register(MovieCreditCell.self, forCellWithReuseIdentifier: creditCellId)
        collectionView.register(MovieButtonsCell.self, forCellWithReuseIdentifier: buttonsCellId)
        collectionView.register(MovieGenresCell.self, forCellWithReuseIdentifier: genresCellId)
        collectionView.register(MovieOverviewCell.self, forCellWithReuseIdentifier: overviewCellId)
        collectionView.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: spacingHeaderId)
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch indexPath.section {
        case 0:
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerId, for: indexPath) as! MovieHeader
          return header
        case 1:
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: creditHeaderId, for: indexPath) as! MovieCreditHeader
            header.titleLabel.text = "Cast"
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
            case 2:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: overviewCellId, for: indexPath) as! MovieOverviewCell
                cell.overviewLabel.text = overviewText
                return cell
            default:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath)
                cell.backgroundColor = .red
                return cell
            }
        default:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: creditCellId, for: indexPath) as! MovieCreditCell

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
            numberOfItems = 3
        case 1:
            numberOfItems = 5
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
                dummyCell.overviewLabel.text = overviewText
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
