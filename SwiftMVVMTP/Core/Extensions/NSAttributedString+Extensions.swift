//
//  NSAttributedString+Extensions.swift
//  SwiftMVVMTP
//
//  Created by Truc Pham on 25/09/2021.
//

import Foundation
import UIKit
extension NSAttributedString {
    func size(considering maxWidth: CGFloat = UIScreen.main.bounds.width) -> CGSize {
        let constraintBox = CGSize(width: maxWidth, height: .greatestFiniteMagnitude)
        let rect = self.boundingRect(with: constraintBox, options: [.usesLineFragmentOrigin, .usesFontLeading], context: nil).integral
        return rect.size
    }
    func setSpaceLines(_ pad: CGFloat = 4) -> NSAttributedString {
        let attr = NSMutableAttributedString()
        let paraStyle = NSMutableParagraphStyle()
        attr.append(self)
        paraStyle.lineSpacing = pad
        attr.addAttribute(.paragraphStyle, value: paraStyle, range: NSMakeRange(0, attr.length))
        return attr
    }
    func setSpaceLines(_ pad: CGFloat = 4, minimumLineHeight: CGFloat = 0) -> NSAttributedString {
        let attr = NSMutableAttributedString()
        let paraStyle = NSMutableParagraphStyle()
        attr.append(self)
        paraStyle.lineSpacing = pad
        paraStyle.minimumLineHeight = minimumLineHeight
        attr.addAttribute(.paragraphStyle, value: paraStyle, range: NSMakeRange(0, attr.length))
        return attr
    }
}
