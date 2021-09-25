//
//  GlidingCollectionDelegate.swift
//  SwiftMVVMTP
//
//  Created by Truc Pham on 25/09/2021.
//

import Foundation

protocol GlidingCollectionDelegate {
    func glidingCollection(_ collection: GlidingCollection, willExpandItemAt index: Int)
    func glidingCollection(_ collection: GlidingCollection, didExpandItemAt index: Int)
    func glidingCollection(_ collection: GlidingCollection, didSelectItemAt index: Int)
    
}

extension GlidingCollectionDelegate {
    
    func glidingCollection(_ collection: GlidingCollection, willExpandItemAt index: Int) { }
    
    func glidingCollection(_ collection: GlidingCollection, didExpandItemAt index: Int) { }
    
    func glidingCollection(_ collection: GlidingCollection, didSelectItemAt index: Int) { }
    
}
