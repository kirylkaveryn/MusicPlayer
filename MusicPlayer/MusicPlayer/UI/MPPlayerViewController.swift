//
//  MPPlayerViewController.swift
//  MusicPlayer
//
//  Created by Kirill on 4.09.22.
//

import UIKit

class MPPlayerViewController: UIViewController {
    
    private let interitemSpace: CGFloat = 30
    private let cellContentInset = UIEdgeInsets(top: 60, left: 60, bottom: 60, right: 60)

    @IBOutlet weak var corouselCollectionView: MPCollectionView!
    @IBOutlet weak var songLabel: UILabel!
    @IBOutlet weak var artistLabel: UILabel!
    @IBOutlet weak var playedTime: UILabel!
    @IBOutlet weak var remainingTIme: UILabel!
    @IBOutlet weak var backwardPlayerButton: UIButton!
    @IBOutlet weak var playPlayerButtom: UIButton!
    @IBOutlet weak var forwardPlayerButton: UIButton!
    @IBOutlet weak var progressBar: UIProgressView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
    }
    
    private func setupCollectionView() {
        corouselCollectionView.delegate = self
        corouselCollectionView.dataSource = self
        corouselCollectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
    }

}

// MARK: CollectionView DataSource
extension MPPlayerViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        cell.backgroundColor = .red
        
        return cell
    }
}


// MARK: CollectionView Delegate

extension MPPlayerViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: collectionView.frame.width - cellContentInset.left - cellContentInset.right, height: collectionView.frame.height - cellContentInset.top - cellContentInset.bottom)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return cellContentInset
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        guard let collectionView = scrollView as? MPCollectionView else { return }
//        if collectionView.contentOffset.x < -50 {
//            collectionView.scrollToItem(at: IndexPath(row: FillingData.data.count - 1, section: 0), at: .centeredHorizontally, animated: true)
//        }
//
//        else if collectionView.contentOffset.x + cellWidth * 1.5 - 50 > collectionView.contentSize.width {
//            collectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .centeredHorizontally, animated: true)
//        }
//
//        collectionView.indexOfPresentedCell = getindexOfPresentedCell(positionX: collectionView.contentOffset.x)
//        changePlayArrow(index: indexOfPresentedCell)
    }
//
//    private func getindexOfPresentedCell(positionX: CGFloat) -> Int {
//        let cellWidth: CGFloat = cellWidth + 20
//        let offset = positionX / cellWidth
//        let index = Int(round(offset))
//        return index
//    }
}


