//
//  BackgroundNeumorphic.swift
//  SwiftMVVMTP
//
//  Created by TrucPham on 14/04/2023.
//  Copyright © 2023 Truc Pham. All rights reserved.
//

import Foundation
import UIKit
class BackgroundCircleNeumorphic : UIView {
    let circleBottomSize : CGFloat = (UIScreen.main.bounds.width + 100)
    private lazy var circleBottomView : CircleInnerShadowView = {
        let v = CircleInnerShadowView()
        v.clipsToBounds = true
        v.layer.masksToBounds = true
        v.layer.cornerRadius = circleBottomSize/2
        v.darkShadowOffset = .init(width: 5, height: 10)
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    let circleTopSize : CGFloat = (UIScreen.main.bounds.width - 30)
    private lazy var circleTopView : CircleInnerShadowView = {
        let v = CircleInnerShadowView()
        v.layer.cornerRadius = circleTopSize/2
        v.clipsToBounds = true
        v.layer.masksToBounds = true
        v.darkShadowOffset = .init(width: 10, height: 5)
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        prepareUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        prepareUI()
    }
    
    private func prepareUI(){
        self.backgroundColor = .Neumorphic.mainColor
        self.clipsToBounds = true
        self.layer.masksToBounds = true
        [circleBottomView, circleTopView].forEach(self.addSubview(_:))
        NSLayoutConstraint.activate([
            self.circleBottomView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: -circleBottomSize/2),
            self.circleBottomView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: circleBottomSize/2 + 100),
            self.circleBottomView.heightAnchor.constraint(equalTo: self.circleBottomView.widthAnchor),
            self.circleBottomView.widthAnchor.constraint(equalToConstant: circleBottomSize),
            
            self.circleTopView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: circleTopSize/2),
            self.circleTopView.topAnchor.constraint(equalTo: self.topAnchor, constant: -circleTopSize/2 - 30),
            self.circleTopView.heightAnchor.constraint(equalTo: self.circleTopView.widthAnchor),
            self.circleTopView.widthAnchor.constraint(equalToConstant: circleTopSize),
            
        ])
    }
}
