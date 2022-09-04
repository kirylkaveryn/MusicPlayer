//
//  MPPlayerViewController.swift
//  MusicPlayer
//
//  Created by Kirill on 4.09.22.
//

import UIKit

class MPPlayerScreenViewController: UIViewController {

    @IBOutlet weak var collectionView: MPCorouselCollectionView!
    @IBOutlet weak var songLabel: UILabel!
    @IBOutlet weak var artistLabel: UILabel!
    @IBOutlet weak var playedTime: UILabel!
    @IBOutlet weak var remainingTIme: UILabel!
    @IBOutlet weak var backwardPlayerButton: UIButton!
    @IBOutlet weak var playPlayerButtom: UIButton!
    @IBOutlet weak var forwardPlayerButton: UIButton!
    @IBOutlet weak var progressBar: UIProgressView!
    
    private var presenter: MPPlayerScreenPresenterProcol?
    private let interitemSpace: CGFloat = 30
    private let cellContentInset = UIEdgeInsets(top: 60, left: 60, bottom: 60, right: 60)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        
        guard let initaialSongModel = presenter?.songs.first else { return }
        self.songLabel.text = initaialSongModel.title
        self.artistLabel.text = initaialSongModel.title
        
    }
    
    func configure(presenter: MPPlayerScreenPresenterProcol) {
        self.presenter = presenter

        presenter.songDidChange = { [weak self] songModel in
            guard let self = self else { return }
            self.songLabel.text = songModel.title
            self.artistLabel.text = songModel.title
        }
    }

    private func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: MPCorouselCollectionViewCell.nibName, bundle: nil), forCellWithReuseIdentifier: MPCorouselCollectionViewCell.reuseID)
    }
    
    
    @IBAction func playButtonDidTap(_ sender: Any) {
        presenter?.playButtonDidTap()
    }
    
    @IBAction func backwardButtonDidTap(_ sender: Any) {
        presenter?.backwardButtonDidTap()
    }
    
    @IBAction func forwardButtonDidTap(_ sender: Any) {
        presenter?.forwardButtonDidTap()
    }

}

// MARK: CollectionView DataSource
extension MPPlayerScreenViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        presenter?.songs.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MPCorouselCollectionViewCell.reuseID, for: indexPath)
        return cell
    }
}


// MARK: CollectionView Delegate

extension MPPlayerScreenViewController: UICollectionViewDelegateFlowLayout {
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



