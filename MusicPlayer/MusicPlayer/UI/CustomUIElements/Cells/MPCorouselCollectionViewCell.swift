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
        contentView.tintColor = .white.withAlphaComponent(0.3)
        contentView.backgroundColor = .white.withAlphaComponent(0.1)
        contentView.layer.borderColor = UIColor.white.withAlphaComponent(0.1).cgColor
        contentView.layer.borderWidth = 2
        contentView.layer.cornerRadius = 10
        contentView.layer.cornerCurve = .continuous
        contentView.clipsToBounds = true
    }
    
    func configure(image: UIImage?) {
        albumImageView.image = image
    }

}
