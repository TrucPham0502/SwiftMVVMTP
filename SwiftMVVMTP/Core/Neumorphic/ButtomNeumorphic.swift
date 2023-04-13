//
//  ButtomNeumorphic.swift
//  SwiftMVVMTP
//
//  Created by TrucPham on 10/04/2023.
//  Copyright © 2023 Truc Pham. All rights reserved.
//

import Foundation
import UIKit

class ButtonNeumorphic : UIButton {
    private let lightShadowLayer = CALayer()
    private let darkShadowLayer = CALayer()
    var mainColor : UIColor? = .Neumorphic.mainColor
    var textColor : UIColor? = .Neumorphic.secondaryColor
    var darkShadowColor : UIColor? = .Neumorphic.darkShadowSolidColor
    var lightShadowColor : UIColor? = .Neumorphic.lightShadowSolidColor
    var padding : UIEdgeInsets = .init(top: 15, left: 35, bottom: 15, right: 35)
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
        self.setTitleColor(isEnabled ? textColor : darkShadowColor, for: .normal)
        self.contentEdgeInsets = padding
        setup()
        layer.addSublayer(lightShadowLayer)
        layer.addSublayer(darkShadowLayer)
        
        addTarget(self, action: #selector(touchDown), for: [.touchDown, .touchDragEnter])
        addTarget(self, action: #selector(touchUp), for: [.touchUpInside, .touchCancel, .touchDragExit])
        layer.cornerRadius = 25
        if let imageView = self.imageView {
            self.bringSubviewToFront(imageView)
        }
        
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
    
    func setBackgroud(isPress: Bool = false){
        if isEnabled {
            self.layer.backgroundColor = mainColor?.cgColor
        }
    }
    
    @objc private func touchDown() {
        animateButton(scale: 0.96, lightShadowOffset: CGSize(width: 1, height: 1), darkShadowOffset: CGSize(width: -1, height: -1), scaleX: 0.97, scaleY: 0.97)
    }
    
    @objc private func touchUp() {
        animateButton(scale: 1.0, lightShadowOffset: lightShadowOffset, darkShadowOffset: darkShadowOffset, scaleX: 1, scaleY: 1)
    }
    
    private func animateButton(scale: CGFloat, lightShadowOffset: CGSize, darkShadowOffset: CGSize, scaleX: CGFloat, scaleY: CGFloat) {
        UIView.animate(withDuration: 0.15) {
            self.transform = CGAffineTransform(scaleX: scale, y: scale)
            self.lightShadowLayer.shadowOffset = lightShadowOffset
            self.darkShadowLayer.shadowOffset = darkShadowOffset
            self.transform = CGAffineTransform(scaleX: scaleX, y: scaleY)
        }
    }
    
    override var isEnabled: Bool {
        didSet {
            self.setTitleColor(isEnabled ? textColor : darkShadowColor, for: .normal)
        }
    }
    
}




