//
//  TextFieldNeumorphic.swift
//  SwiftMVVMTP
//
//  Created by TrucPham on 10/04/2023.
//  Copyright © 2023 Truc Pham. All rights reserved.
//

import Foundation
import UIKit

class NeumorphicTextField: UITextField {
    
    private let darkShadowLayer = CALayer()
    private let lightShadowLayer = CALayer()
    var mainColor : UIColor = .Neumorphic.defaultMainColor
    var darkShadowColor : UIColor = .Neumorphic.defaultDarkShadowSolidColor
    var lightShadowColor : UIColor = .Neumorphic.defaultLightShadowSolidColor
    var padding : UIEdgeInsets = .init(top: 16, left: 25, bottom: 16, right: 25)
    var lightShadowOffset = CGSize(width: -2, height: -2)
    var darkShadowOffset : CGSize {
        return isEditing ? CGSize(width: 6, height: 6) : CGSize(width: 4, height: 4)
    }
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        prepareUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        prepareUI()
        
    }
    
    private func prepareUI(){
        let paddingLeftView = UIView(frame: CGRect(x: 0, y: 0, width: padding.left, height: 0))
        leftView = paddingLeftView
        leftViewMode = .always
        
        let paddingRightView = UIView(frame: CGRect(x: 0, y: 0, width: padding.right, height: 0))
        rightView = paddingRightView
        rightViewMode = .always
        
        layer.addSublayer(lightShadowLayer)
        layer.addSublayer(darkShadowLayer)
        
    }
    
    
    private func createDarkPath(_ offset: CGSize) -> UIBezierPath {
        let radius = self.layer.cornerRadius
        darkShadowLayer.frame = bounds
        let darkPath = UIBezierPath(roundedRect: darkShadowLayer.bounds.insetBy(dx: -darkShadowOffset.width, dy:-darkShadowOffset.height), cornerRadius:radius)
        let darkCutout = UIBezierPath(roundedRect: darkShadowLayer.bounds, cornerRadius:radius).reversing()
        darkPath.append(darkCutout)
        return darkPath
    }
    private func createLightPath(_ offset : CGSize) -> UIBezierPath {
        let radius = self.layer.cornerRadius
        lightShadowLayer.frame = bounds
        let lightPath = UIBezierPath(roundedRect: lightShadowLayer.bounds.insetBy(dx: -lightShadowOffset.width, dy:-lightShadowOffset.height), cornerRadius:radius)
        let lightCutout = UIBezierPath(roundedRect: lightShadowLayer.bounds, cornerRadius:radius).reversing()
        lightPath.append(lightCutout)
        return lightPath
    }
    
    private func setup(){
        let radius = self.layer.cornerRadius
        darkShadowLayer.shadowPath = self.createDarkPath(self.darkShadowOffset).cgPath
        darkShadowLayer.masksToBounds = true
        // Shadow properties
        darkShadowLayer.shadowColor = darkShadowColor.cgColor
        darkShadowLayer.shadowOffset = darkShadowOffset
        darkShadowLayer.shadowOpacity = 0.5
        darkShadowLayer.shadowRadius = 2
        darkShadowLayer.cornerRadius = radius
        
        
        lightShadowLayer.shadowPath = createLightPath(self.lightShadowOffset).cgPath
        lightShadowLayer.masksToBounds = true
        // Shadow properties
        lightShadowLayer.shadowColor = lightShadowColor.cgColor
        lightShadowLayer.shadowOffset = lightShadowOffset
        lightShadowLayer.shadowOpacity = 0.5
        lightShadowLayer.shadowRadius = 2
        lightShadowLayer.cornerRadius = radius
        
    }

    
    override func layoutSubviews() {
        super.layoutSubviews()
        setup()
    }
    
    
}
