//
//  UILabel+Extensions.swift
//  SwiftMVVMTP
//
//  Created by Truc Pham on 25/09/2021.
//

import Foundation
import UIKit
extension UILabel {
    func labelSize(considering maxWidth: CGFloat = UIScreen.main.bounds.width) -> CGSize {
        return self.attributedText?.size(considering: maxWidth) ?? .zero
    }
    func setLineHeight(_ number: CGFloat) {
        self.attributedText = self.attributedText?.setSpaceLines(0, minimumLineHeight: number)
    }
}
