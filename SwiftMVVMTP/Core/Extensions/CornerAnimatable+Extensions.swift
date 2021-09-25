//
//  CornerAnimatable+Extensions.swift
//  SwiftMVVMTP
//
//  Created by Truc Pham on 25/09/2021.
//

import Foundation
import UIKit
protocol CornerAnimatable {
    func animationCornerRadius(_ radius: CGFloat, duration: Double)
}

extension CornerAnimatable where Self: UIView {

    func animationCornerRadius(_ radius: CGFloat, duration: Double) {
        let animation = CABasicAnimation(keyPath: "cornerRadius")
        animation.duration = duration
        animation.toValue = radius
        animation.fillMode = CAMediaTimingFillMode.forwards
        animation.isRemovedOnCompletion = false
        

        layer.add(animation, forKey: nil)
    }
}

extension UIView: CornerAnimatable {}
