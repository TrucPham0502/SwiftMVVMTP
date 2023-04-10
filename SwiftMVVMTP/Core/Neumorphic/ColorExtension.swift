//
//  ColorExtension.swift
//  SwiftMVVMTP
//
//  Created by TrucPham on 10/04/2023.
//  Copyright © 2023 Truc Pham. All rights reserved.
//

import Foundation
import UIKit
extension UIColor {
    
    struct Neumorphic {
        //Color
        static var mainColor : UIColor! {
            return UIColor(named: "neumorphic-main-color")
        }
        static var secondaryColor : UIColor! {
            return UIColor(named: "neumorphic-secondary-color")
        }
        static var lightShadowSolidColor : UIColor! {
            return UIColor(named: "neumorphic-light-shadow-solid-color")
        }
        static var darkShadowSolidColor : UIColor! {
            return UIColor(named: "neumorphic-dark-shadow-solid-color")
        }
    }
    
}
