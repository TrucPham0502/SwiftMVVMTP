//
//  UIHomeConfig.swift
//  SwiftMVVMTP
//
//  Created by Truc Pham on 25/09/2021.
//

import Foundation
import UIKit
struct UIMovieHomeConfig {
     var yOffsetItem = CGFloat(40)
    /// Shared instance of configuration.
    /// Override this property or change values directly.
     static var shared = UIMovieHomeConfig()
    
    /// Side insets of GlidiingCollection view.
    /// Only left & right side insets will take effect.
     var sideInsets = UIEdgeInsets(top: 20, left: 30, bottom: 10, right: 30)
    
    /// Duration of animation between GlidingCollection sections.
     var animationDuration: Double = 0.3
    
    /// Spacing between vertical stack of items.
     var buttonsSpacing: CGFloat = 15
    
    /// Font of each element in vertical stack.
     var buttonsFont = UIFont.boldSystemFont(ofSize: 30)
    
    /// Scale factor of inactive sections buttons.
     var buttonsScaleFactor: CGFloat = 0.5
    
    /// Active section button color.
     var activeButtonColor: UIColor = .white
    
    /// Inactive sections buttons color.
    var inactiveButtonsColor: UIColor = .white.withAlphaComponent(0.5)
    
    
    /// Size of collectionView's cells.
    var cardsSize = CGSize(width: min(270, UIScreen.main.bounds.width - 120), height: min(270, UIScreen.main.bounds.width - 120) * 360 / 270)
   
    
    
}
