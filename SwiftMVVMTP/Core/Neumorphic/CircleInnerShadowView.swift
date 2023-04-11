//
//  CircleInnerShadowView.swift
//  SwiftMVVMTP
//
//  Created by TrucPham on 11/04/2023.
//  Copyright © 2023 Truc Pham. All rights reserved.
//

import Foundation
import UIKit
class CircleInnerShadowView : UIView {
    private var darkPath = UIBezierPath()
    private let darkShadowLayer = CALayer()
    var mainColor : UIColor? = .Neumorphic.mainColor
    var darkShadowColor : UIColor? = .Neumorphic.darkShadowSolidColor
    var darkShadowOffset : CGSize = CGSize(width: 10, height: 10)
    override init(frame: CGRect) {
        super.init(frame: frame)
        prepareUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        prepareUI()
    }
    private func prepareUI(){
        self.layer.addSublayer(darkShadowLayer)
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.darkShadowLayer.frame = bounds
        self.darkShadowLayer.shadowPath = createDarkPath(self.darkShadowOffset).cgPath
        darkShadowLayer.masksToBounds = true
        // Shadow properties
        darkShadowLayer.shadowColor = darkShadowColor?.cgColor
        darkShadowLayer.shadowOffset = darkShadowOffset
        darkShadowLayer.shadowOpacity = 0.5
        darkShadowLayer.shadowRadius = 2
        darkShadowLayer.cornerRadius = self.layer.cornerRadius
    }
    
    private func createDarkPath(_ offset: CGSize) -> UIBezierPath {
        let radius = self.layer.cornerRadius
        darkShadowLayer.frame = bounds
        let darkPath = UIBezierPath(roundedRect: darkShadowLayer.bounds.insetBy(dx: -offset.width, dy:-offset.height), cornerRadius:radius)
        let darkCutout = UIBezierPath(roundedRect: darkShadowLayer.bounds, cornerRadius:radius).reversing()
        darkPath.append(darkCutout)
        return darkPath
    }
}
