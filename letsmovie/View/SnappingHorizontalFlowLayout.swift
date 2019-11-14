//
//  SnappingHorizontalFlowLayout.swift
//  letsmovie
//
//  Created by Panupong Kukutapan on 15/11/2562 BE.
//  Copyright © 2562 Panupong Kukutapan. All rights reserved.
//

import UIKit

class SnappingHorizontalFlowLayout: UICollectionViewFlowLayout {
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        guard let collectionView = self.collectionView else {
            return super.targetContentOffset(forProposedContentOffset: proposedContentOffset, withScrollingVelocity: velocity)
        }
        
        var minDistance = CGFloat.greatestFiniteMagnitude
        let horizontalWithOffset = proposedContentOffset.x + collectionView.contentInset.left
        let targetRect = CGRect(x: proposedContentOffset.x, y: 0, width: collectionView.frame.width, height: collectionView.frame.height)
        let layoutAttributes = super.layoutAttributesForElements(in: targetRect)
        print(horizontalWithOffset)
        layoutAttributes?.forEach {
            let rectOffsetX = $0.frame.origin.x
            if abs(horizontalWithOffset - rectOffsetX) < abs(minDistance) {
                minDistance = rectOffsetX - horizontalWithOffset
            }
        }
        
        return .init(x: horizontalWithOffset + minDistance - collectionView.contentInset.left, y: proposedContentOffset.y)
    }
}
