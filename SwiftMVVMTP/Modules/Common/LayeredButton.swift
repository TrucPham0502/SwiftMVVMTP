//
//  LayeredView.swift
//  SwiftMVVMTP
//
//  Created by Truc Pham on 02/04/2023.
//  Copyright © 2023 Truc Pham. All rights reserved.
//

import Foundation
import UIKit
class LayeredButton: UIButton {
    
    private let foregroundLayer = CALayer()
    private let backgroundLayer1 = CALayer()
    private let backgroundLayer2 = CALayer()
    
    override var bounds: CGRect {
        didSet { updateFrames() }
    }
    
    override var frame: CGRect {
        didSet { updateFrames() }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layout()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        layout()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        [backgroundLayer1, backgroundLayer2, foregroundLayer].forEach { layer in
            layer.cornerRadius = self.layer.cornerRadius
            layer.masksToBounds = true
        }
    }
    
    private func layout() {
        backgroundColor = UIColor.clear
        [backgroundLayer1, backgroundLayer2, foregroundLayer].forEach(self.layer.addSublayer)
        
        foregroundLayer.backgroundColor = UIColor(named: "primary-color")?.cgColor
        backgroundLayer1.backgroundColor = UIColor(named: "secondary-primary-color")?.cgColor
        backgroundLayer2.backgroundColor = UIColor(red: 0.01, green: 0.80, blue: 0.97, alpha: 1.00).cgColor
    }
    
    private func updateFrames() {
        let insets = CGSize(width: 5.5, height: 3)
        foregroundLayer.frame = bounds.inset(
            by: UIEdgeInsets(top: insets.height, left: insets.width, bottom: insets.height, right: insets.width)
        )
        backgroundLayer1.frame = bounds.inset(
            by: UIEdgeInsets(top: 0, left: 2 * insets.width, bottom: 2 * insets.height, right: 0)
        )
        backgroundLayer2.frame = bounds.inset(
            by: UIEdgeInsets(top: 2 * insets.height, left: 0, bottom: 0, right: 2 * insets.width)
        )
    }
}
