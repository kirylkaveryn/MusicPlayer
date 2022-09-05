//
//  MPProgressView.swift
//  MusicPlayer
//
//  Created by Kirill on 5.09.22.
//

import UIKit

//class MPProgressView: UIProgressView {
//
//    @IBInspectable var progressCapView: MPProgressCapView?
//
//    @available(*, unavailable)
//    required init?(coder: NSCoder) {
//        super.init(coder: coder)
//        setupView()
//    }
//
//    private func setupView() {
//        progressCapView = MPProgressCapView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
//        guard let progressCapView = progressCapView else { return }
//        addSubview(progressCapView)
//        progressCapView.backgroundColor = backgroundColor
////        progressCapView.center =
//        clipsToBounds = false
//        layer.masksToBounds = false
//
//        let s = UISlider()
//        print(progressCapView.frame)
//    }
//
//}
//
//class MPProgressCapView: UIView {
//
//    var radius: CGFloat {
//        set { layer.cornerRadius = bounds.height / 2 }
//        get { bounds.height }
//    }
//
//    override func layoutSubviews() {
//        super.layoutSubviews()
//        layer.cornerRadius = bounds.height / 2
//    }
//
//}
//
//class MPSlider: UISlider {
//    
//    @available(*, unavailable)
//    required init?(coder: NSCoder) {
//        super.init(coder: coder)
//        setupView()
//    }
//    
//    private func setupView() {
//
//        let thumb = setThumbImage(<#T##image: UIImage?##UIImage?#>, for: <#T##UIControl.State#>)
//    }
//
//    private func thumbImage(radius: CGFloat) -> UIImage {
//         thumbView.frame = CGRect(x: 0, y: radius / 2, width: radius, height: radius)
//         thumbView.layer.cornerRadius = radius / 2
//
//         let renderer = UIGraphicsImageRenderer(bounds: thumbView.bounds)
//         return renderer.image { rendererContext in
//             thumbView.layer.render(in: rendererContext.cgContext)
//         }
//     }
//     
//     override func trackRect(forBounds bounds: CGRect) -> CGRect {
//         var newRect = super.trackRect(forBounds: bounds)
//         newRect.size.height = trackHeight
//         return newRect
//     }
//    
//    
//}
//
//class MPProgressCapView: UIView {
//
//    var radius: CGFloat {
//        set { layer.cornerRadius = bounds.height / 2 }
//        get { bounds.height }
//    }
//
//    override func layoutSubviews() {
//        super.layoutSubviews()
//        layer.cornerRadius = bounds.height / 2
//    }
//
//}
