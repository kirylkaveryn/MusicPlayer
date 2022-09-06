//
//  RSPlayerArrowButton.swift.swift
//  GameConter
//
//  Created by Kirill on 27.08.21.
//

import UIKit

enum MPPlayerControlStyle {
    case goBack
    case goForward
    case play
    case pause
}

enum MPPlayerControlSize {
    case standart
    case big
}

extension MPPlayerControlSize {
    var size: CGFloat {
        switch self {
        case .standart:
            return 30
        case .big:
            return 80
        }
    }
    
    var insets: UIEdgeInsets {
        switch self {
        case .standart:
            return .zero
        case .big:
            return UIEdgeInsets.init(top: 20, left: 20, bottom: -20, right: -20)
        }
    }
}

class MPPlayerControlButton: UIButton {
    
    var controlStyle: MPPlayerControlStyle? {
        didSet {
            switch controlStyle {
            case .goBack:
                setImage(UIImage(systemName: "backward.end"), for: .normal)
            case .goForward:
                setImage(UIImage(systemName: "forward.end"), for: .normal)
            case .play:
                setImage(UIImage(systemName: "play.fill"), for: .normal)
            case .pause:
                setImage(UIImage(systemName: "pause.fill"), for: .normal)
            case .none:
                break
            }
        }
    }
    
    private var controlSize: MPPlayerControlSize = .standart {
        didSet {
            switch controlSize {
            case .standart:
                backgroundColor = .clear
            case .big:
                backgroundColor = .clear
                layer.backgroundColor = UIColor.white.withAlphaComponent(0.05).cgColor
                layer.masksToBounds = false
                layer.shadowRadius = 50
                layer.shadowColor = UIColor.black.cgColor
                layer.shadowOpacity = 1.0
            }
        }
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setupView() {
        tintColor = .white
        setTitle("", for: .normal)
        contentMode = .scaleAspectFit
        imageView?.contentMode = .scaleAspectFit
    }

    func confugure(style: MPPlayerControlStyle, size: MPPlayerControlSize) {
        self.controlStyle = style
        self.controlSize = size
        activateDimensionConstraints()
        setupView()
    }
    
    private func activateDimensionConstraints() {
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalToConstant: controlSize.size),
            widthAnchor.constraint(equalToConstant: controlSize.size),
        ])
        
        guard let imageView = imageView else { return }
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: controlSize.insets.left),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: controlSize.insets.right),
            imageView.topAnchor.constraint(equalTo: topAnchor, constant: controlSize.insets.top),
            imageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: controlSize.insets.bottom),
        ])
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = bounds.height / 2
        layer.shadowPath = UIBezierPath(roundedRect: layer.bounds, cornerRadius: bounds.height / 2).cgPath
    }

}

