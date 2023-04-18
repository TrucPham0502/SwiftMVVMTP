//
//  UIHomeConfig.swift
//  SwiftMVVMTP
//
//  Created by Truc Pham on 25/09/2021.
//

import Foundation
import UIKit
public struct UIMovieHomeConfig {
    public var yOffsetItem = CGFloat(40)
    /// Shared instance of configuration.
    /// Override this property or change values directly.
    public static var shared = UIMovieHomeConfig()
    
    /// Side insets of GlidiingCollection view.
    /// Only left & right side insets will take effect.
    public var sideInsets = UIEdgeInsets(top: 20, left: 30, bottom: 10, right: 30)
    
    /// Duration of animation between GlidingCollection sections.
    public var animationDuration: Double = 0.3
    
    /// Spacing between vertical stack of items.
    public var buttonsSpacing: CGFloat = 15
    
    /// Font of each element in vertical stack.
    public var buttonsFont = UIFont.boldSystemFont(ofSize: 30)
    
    /// Scale factor of inactive sections buttons.
    public var buttonsScaleFactor: CGFloat = 0.5
    
    /// Active section button color.
    public var activeButtonColor: UIColor = .white
    
    /// Inactive sections buttons color.
    public var inactiveButtonsColor: UIColor = .lightGray
    
    
    /// Size of collectionView's cells.
    public var cardsSize = CGSize(width: 256, height: 340)
   
    
    
}
