//
//  UILabel+Extensions.swift
//  SwiftMVVMTP
//
//  Created by Truc Pham on 25/09/2021.
//

import Foundation
extension UILabel {
    func labelSize(considering maxWidth: CGFloat = UIScreen.main.bounds.width) -> CGSize {
        return self.attributedText?.size(considering: maxWidth) ?? .zero
    }
}
