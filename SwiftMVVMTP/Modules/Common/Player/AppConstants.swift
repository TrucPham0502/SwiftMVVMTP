//
//  AppConstants.swift
//  TPPlayer
//
//  Created by TrucPham on 04/10/2021.
//

import Foundation
import UIKit
class AppConstants {
    internal init(left: NSLayoutConstraint? = nil, right: NSLayoutConstraint? = nil, bottom: NSLayoutConstraint? = nil, top: NSLayoutConstraint? = nil, width: NSLayoutConstraint? = nil, height: NSLayoutConstraint? = nil, centerX : NSLayoutConstraint? = nil, centerY : NSLayoutConstraint? = nil) {
        self.left = left
        self.right = right
        self.bottom = bottom
        self.top = top
        self.width = width
        self.height = height
        self.centerX = centerX
        self.centerY = centerY
    }
    let left : NSLayoutConstraint?
    let right : NSLayoutConstraint?
    let bottom : NSLayoutConstraint?
    let top : NSLayoutConstraint?
    let width : NSLayoutConstraint?
    let height : NSLayoutConstraint?
    let centerX : NSLayoutConstraint?
    let centerY : NSLayoutConstraint?
    
    func active(){
        [self.left, self.right, self.bottom, self.top, self.width, self.height, self.centerX, self.centerY].forEach({ $0?.isActive = true})
    }
}

struct SaveContraint {
    let left : CGFloat?
    let right: CGFloat?
    let top : CGFloat?
    let bottom : CGFloat?
    let centerX : CGFloat?
    let centerY : CGFloat?
    let height : CGFloat?
    let width : CGFloat?
    init(_ constraint: AppConstants? = nil){
        self.left = constraint?.left?.constant
        self.right = constraint?.right?.constant
        self.top = constraint?.top?.constant
        self.bottom = constraint?.bottom?.constant
        self.centerX = constraint?.centerX?.constant
        self.centerY = constraint?.centerY?.constant
        self.height = constraint?.height?.constant
        self.width = constraint?.width?.constant
    }
}
