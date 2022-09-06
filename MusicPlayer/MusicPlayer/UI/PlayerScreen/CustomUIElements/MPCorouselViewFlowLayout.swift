//
//  MPCorouselViewFlowLayout.swift
//  MusicPlayer
//
//  Created by Kirill on 4.09.22.
//

import UIKit

class MPCorouselViewFlowLayout: UICollectionViewFlowLayout {
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        scrollDirection = .horizontal
        minimumLineSpacing = 30
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        true
    }
    
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        guard let collectionView = collectionView as? MPCorouselCollectionView,
              let currentCell = collectionView.visibleCells.first else {
            return proposedContentOffset }
        
        let pageWidth = currentCell.bounds.width + minimumLineSpacing
        
        let currentXOffset = collectionView.contentOffset.x
        let nextXOffset = proposedContentOffset.x
        let maxIndex = ceil(currentXOffset / pageWidth)
        let minIndex = floor(currentXOffset / pageWidth)
        
        var index: CGFloat = 0
        
        if nextXOffset > currentXOffset {
            index = maxIndex
        } else {
            index = minIndex
        }
        
        let xOffset = pageWidth * index
        let point = CGPoint(x: xOffset, y: 0)
        collectionView.indexOfPresentedCell = Int(index)
        return point
    }

}
