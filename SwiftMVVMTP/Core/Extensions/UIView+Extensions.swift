//
//  UIView+Extensions.swift
//  SwiftMVVMTP
//
//  Created by Truc Pham on 25/09/2021.
//

import Foundation
import UIKit
extension UIView {
    func getConstraint(_ attributes: NSLayoutConstraint.Attribute) -> NSLayoutConstraint? {
        return constraints.filter {
            if $0.firstAttribute == attributes && $0.secondItem == nil {
                return true
            }
            return false
        }.first
    }
    func takeSnapshot(_ frame: CGRect) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(frame.size, false, 0.0)

        let context = UIGraphicsGetCurrentContext()
        context?.translateBy(x: frame.origin.x * -1, y: frame.origin.y * -1)

        guard let currentContext = UIGraphicsGetCurrentContext() else {
            return nil
        }

        layer.render(in: currentContext)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return image
    }
    func setShadow(_ size : CGSize = CGSize(width: 0, height: 5), radius: CGFloat = 2, opacity : Float = 0.2){
        self.layer.shadowRadius = radius
        self.layer.shadowOffset = size
        self.layer.shadowOpacity = opacity
    }
}
