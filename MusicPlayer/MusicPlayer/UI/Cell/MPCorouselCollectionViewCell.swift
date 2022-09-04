//
//  MPCorouselCollectionViewCell.swift
//  MusicPlayer
//
//  Created by Kirill on 4.09.22.
//

import UIKit

class MPCorouselCollectionViewCell: UICollectionViewCell {

    static let reuseID = "MPCorouselCollectionViewCell"
    static let nibName = reuseID
    
    @IBOutlet weak var albumImageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        setupContentView()
    }
    
    private func setupContentView() {
        contentView.layer.cornerRadius = 20
        contentView.layer.cornerCurve = .continuous
        contentView.clipsToBounds = false
    }
    
    func configure(image: UIImage) {
        albumImageView.image = image
    }

}
