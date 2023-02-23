//
//  CGFloat+Extensions.swift
//  SwiftMVVMTP
//
//  Created by Truc Pham on 25/09/2021.
//

import Foundation
import UIKit
extension CGFloat {
    func scaleWidthByScreen() -> CGFloat {
        return self * UIScreen.main.bounds.width / 390
    }
    func scaleHeightByScreen() -> CGFloat {
        return self * UIScreen.main.bounds.height / 844
    }
}
