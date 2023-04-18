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
    var insets = CGSize(width: 5.5, height: 3)
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
        updateFrames()
    }
    
    private func layout() {
        backgroundColor = UIColor.clear
        [backgroundLayer1, backgroundLayer2, foregroundLayer].forEach(self.layer.addSublayer)
        
        foregroundLayer.backgroundColor = UIColor(named: "primary-color")?.cgColor
        backgroundLayer1.backgroundColor = UIColor(named: "secondary-primary-color")?.cgColor
        backgroundLayer2.backgroundColor = UIColor(red: 0.01, green: 0.80, blue: 0.97, alpha: 1.00).cgColor
        
        if let imageView = self.imageView {
            self.bringSubviewToFront(imageView)
        }
    }
    
    private func updateFrames() {
        
        foregroundLayer.frame = .init(origin: .zero, size: bounds.size)
        
        backgroundLayer1.frame = .init(origin: .init(x: insets.width, y: -2 * insets.height), size: bounds.size)
        
        backgroundLayer2.frame = .init(origin: .init(x: -2 * insets.width, y: 2 * insets.height), size: bounds.size)
        
        [backgroundLayer1, backgroundLayer2, foregroundLayer].forEach { layer in
            layer.cornerRadius = self.layer.cornerRadius
            layer.masksToBounds = true
        }
    }
}
