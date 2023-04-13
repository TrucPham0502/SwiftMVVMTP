//
//  UIViewNeumorphic.swift
//  SwiftMVVMTP
//
//  Created by TrucPham on 13/04/2023.
//  Copyright © 2023 Truc Pham. All rights reserved.
//

import Foundation
import UIKit
class UIViewNeumorphic : UIView {
    private let lightShadowLayer = CALayer()
    private let darkShadowLayer = CALayer()
    var mainColor : UIColor? = .Neumorphic.mainColor
    var textColor : UIColor? = .Neumorphic.secondaryColor
    var darkShadowColor : UIColor? = .Neumorphic.darkShadowSolidColor
    var lightShadowColor : UIColor? = .Neumorphic.lightShadowSolidColor
    var lightShadowOffset = CGSize(width: -6, height: -6)
    var darkShadowOffset = CGSize(width: 6, height: 6)
    override init(frame: CGRect) {
        super.init(frame: frame)
        prepareUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func prepareUI(){
        setup()
        layer.addSublayer(lightShadowLayer)
        layer.addSublayer(darkShadowLayer)
    }
    
    private func setup() {
        backgroundColor = mainColor
        
        lightShadowLayer.cornerRadius = layer.cornerRadius
        lightShadowLayer.backgroundColor = mainColor?.cgColor
        lightShadowLayer.shadowColor = lightShadowColor?.cgColor
        lightShadowLayer.shadowOffset = lightShadowOffset
        lightShadowLayer.shadowOpacity = 0.5
        lightShadowLayer.shadowRadius = 3
        
        darkShadowLayer.cornerRadius = layer.cornerRadius
        darkShadowLayer.backgroundColor = mainColor?.cgColor
        darkShadowLayer.shadowColor = darkShadowColor?.cgColor
        darkShadowLayer.shadowOffset = darkShadowOffset
        darkShadowLayer.shadowOpacity = 0.5
        darkShadowLayer.shadowRadius = 3
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        lightShadowLayer.frame = bounds
        darkShadowLayer.frame = bounds
        setup()
    }
}
