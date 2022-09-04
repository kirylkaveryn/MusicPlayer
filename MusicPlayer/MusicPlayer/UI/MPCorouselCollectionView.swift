//
//  MPCollectionView.swift
//  MusicPlayer
//
//  Created by Kirill on 4.09.22.
//

import UIKit

class MPCorouselCollectionView: UICollectionView {

    var indexOfPresentedCell = 0
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.sutupCollectionView()
    }
    
    private func sutupCollectionView() {
        backgroundColor = UIColor.clear
        allowsSelection = false
        showsHorizontalScrollIndicator = false
        showsVerticalScrollIndicator = false
        decelerationRate = .fast
    }

}
