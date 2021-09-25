//
//  GlidingCollectionDatasource.swift
//  SwiftMVVMTP
//
//  Created by Truc Pham on 25/09/2021.
//

import Foundation
protocol GlidingCollectionDatasource {
  
  func numberOfItems(in collection: GlidingCollection) -> Int
  
  func glidingCollection(_ collection: GlidingCollection, itemAtIndex index: Int) -> String
  
}
