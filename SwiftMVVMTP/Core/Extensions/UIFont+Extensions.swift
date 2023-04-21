//
//  UIFont+Extensions.swift
//  SwiftMVVMTP
//
//  Created by TrucPham on 21/04/2023.
//  Copyright © 2023 Truc Pham. All rights reserved.
//

import Foundation
import UIKit
extension UIFont {
    static func regular(ofSize: CGFloat) -> UIFont {
        return UIFont(name: "Baskerville", size: ofSize)!
    }
    static func italic(ofSize: CGFloat) -> UIFont {
        return UIFont(name: "Baskerville-Italic", size: ofSize)!
    }
    static func bold(ofSize: CGFloat) -> UIFont {
        return UIFont(name: "Baskerville-Bold", size: ofSize)!
    }
    static func semiBold(ofSize: CGFloat) -> UIFont {
        return UIFont(name: "Baskerville-SemiBold", size: ofSize)!
    }
    static func semiBoldItalic(ofSize: CGFloat) -> UIFont {
        return UIFont(name: "Baskerville-SemiBoldItalic", size: ofSize)!
    }
    static func boldItalic(ofSize: CGFloat) -> UIFont {
        return UIFont(name: "Baskerville-BoldItalic", size: ofSize)!
    }
}
