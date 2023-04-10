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
        static let defaultMainColor = UIColor(red: 0.925, green: 0.941, blue: 0.953, alpha: 1.0)
        static let defaultSecondaryColor = UIColor(red: 0.482, green: 0.502, blue: 0.549, alpha: 1.0)
        static let defaultLightShadowSolidColor = UIColor(red: 1.000, green: 1.000, blue: 1.000, alpha: 1.0)
        static let defaultDarkShadowSolidColor = UIColor(red: 0.820, green: 0.851, blue: 0.902, alpha: 1.0)
        
        static let darkThemeMainColor = UIColor(red: 0.188, green: 0.192, blue: 0.208, alpha: 1.0)
        static let darkThemeSecondaryColor = UIColor(red: 0.910, green: 0.910, blue: 0.910, alpha: 1.0)
        static let darkThemeLightShadowSolidColor = UIColor(red: 0.243, green: 0.247, blue: 0.275, alpha: 1.0)
        static let darkThemeDarkShadowSolidColor = UIColor(red: 0.137, green: 0.137, blue: 0.137, alpha: 1.0)
    }
    
}
