//
//  MPPlayerViewController.swift
//  MusicPlayer
//
//  Created by Kirill on 4.09.22.
//

import UIKit
import CoreMedia

class MPPlayerScreenViewController: UIViewController {

    @IBOutlet weak var collectionView: MPCorouselCollectionView!
    @IBOutlet weak var trackLabel: UILabel!
    @IBOutlet weak var artistLabel: UILabel!
    @IBOutlet weak var playedTime: UILabel!
    @IBOutlet weak var remainingTIme: UILabel!
    @IBOutlet weak var backwardPlayerButton: MPPlayerControlButton!
    @IBOutlet weak var playPlayerButton: MPPlayerControlButton!
    @IBOutlet weak var forwardPlayerButton: MPPlayerControlButton!
    @IBOutlet weak var progressBar: UIProgressView!
    
    private var presenter: MPPlayerScreenPresenterProtocol?
    private let interitemSpace: CGFloat = 30
    private let cellContentInset = UIEdgeInsets(top: 60, left: 60, bottom: 60, right: 60)
    private var currentIndex: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupButtons()
        setupCollectionView()
        
        presenter?.bind()
    }
    
    func configure(presenter: MPPlayerScreenPresenterProtocol) {
        self.presenter = presenter

        presenter.trackDidChange = { [weak self] title, artist, index in
            guard let self = self else { return }
            self.trackLabel.text = title
            self.artistLabel.text = artist
        }
        
        presenter.progressDidChange = { [weak self] progress in
            guard let self = self else { return }
            let fraction = CMTimeGetSeconds(progress.currentTime) / CMTimeGetSeconds(progress.duration)
            // handle unexpected NaN value
            if !fraction.isNaN {
                self.progressBar.setProgress(Float(fraction), animated: true)
                self.playedTime.text = progress.currentTime.positionalTime
                self.remainingTIme.text = (progress.duration - progress.currentTime).positionalTime
            }
        }
    }
    
    private func setupButtons() {
        forwardPlayerButton.confugure(style: .goForward, size: .standart)
        backwardPlayerButton.confugure(style: .goBack, size: .standart)
        playPlayerButton.confugure(style: .play, size: .big)
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
        scrollToIndex(index: collectionView.indexOfPresentedCell - 1)
    }
    
    @IBAction func forwardButtonDidTap(_ sender: Any) {
        presenter?.forwardButtonDidTap()
        scrollToIndex(index: collectionView.indexOfPresentedCell + 1)
    }
    
    private func scrollToIndex(index: Int) {
        guard let presenter = presenter else { return }
        let targetIndex: Int
        switch index {
        case -1:
            targetIndex = presenter.tracksCount - 1
        case presenter.tracksCount:
            targetIndex = 0
        default:
            targetIndex = index
        }
        collectionView.scrollToItem(at: IndexPath(item: targetIndex, section: 0), at: .centeredHorizontally, animated: true)
    }

}

// MARK: CollectionView DataSource
extension MPPlayerScreenViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        presenter?.tracksCount ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MPCorouselCollectionViewCell.reuseID, for: indexPath) as! MPCorouselCollectionViewCell
        cell.configure(image: presenter?.tracksImages[indexPath.item])
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
        // safe uwrap elements
        guard let collectionView = scrollView as? MPCorouselCollectionView,
        let presenter = presenter,
        let currentCell = collectionView.visibleCells.first else { return }
        
        // delta is for UX
        let delta: CGFloat = 50
        
        // get current cell width
        let cellWidth = currentCell.bounds.width
        
        // scroll to 1st ol last cell if offset is out ob bounts
        // (user dgrag collection forward/backward when last/firs cell is current visible)
        if collectionView.contentOffset.x < -delta {
            collectionView.scrollToItem(at: IndexPath(row: presenter.tracksCount - 1, section: 0), at: .centeredHorizontally, animated: true)
        } else if collectionView.contentOffset.x + cellWidth * 1.1 + delta > collectionView.contentSize.width {
            collectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .centeredHorizontally, animated: true)
        }
        
        // set current presented index
        // Because MPCorouselViewFlowLayout's method targetContentOffset(forProposedContentOffset...
        // is called only when user drag collection view (touching screen).
        // If collection view is scrolled programmatically current presented index
        // should be calculated and set here
        let offset = collectionView.contentOffset.x / cellWidth
        let index = Int(round(offset))
        collectionView.indexOfPresentedCell = index
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        presenter?.goToSong(inex: collectionView.indexOfPresentedCell)
    }

}



