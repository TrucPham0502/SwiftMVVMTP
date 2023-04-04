//
//  MovieCollectionView.swift
//  SwiftMVVMTP
//
//  Created by Truc Pham on 24/09/2021.
//

import Foundation
import UIKit

class MovieCollectionView: UICollectionView {
}

// MARK: init

extension MovieCollectionView {
    
    class func createOnView(_ view: UIView,
                            layout: UICollectionViewLayout,
                            height: CGFloat,
                            dataSource: UICollectionViewDataSource,
                            delegate: UICollectionViewDelegate) -> MovieCollectionView {
        
        let collectionView = MovieCollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.decelerationRate = UIScrollView.DecelerationRate.fast
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.dataSource = dataSource
        collectionView.delegate = delegate
        collectionView.backgroundColor = UIColor(white: 0, alpha: 0)
        collectionView.register(MovieCollectionViewCell.self, forCellWithReuseIdentifier: String(describing: MovieCollectionViewCell.self))
        return collectionView
    }
    
    var currentIndex: Int {
        guard let collectionLayout = self.collectionViewLayout as? MovieCollectionLayout else {
            return 0
        }
        let startOffset = (self.bounds.size.width - collectionLayout.itemSize.width) / 2
        
        let minimumLineSpacing = collectionLayout.minimumLineSpacing
        let a = self.contentOffset.x + startOffset + collectionLayout.itemSize.width / 2
        let b = collectionLayout.itemSize.width + minimumLineSpacing
        return Int(a / b)
    }
    
    var currentCell : MovieCollectionViewCell? {
        return self.cellForItem(at: IndexPath(row: self.currentIndex, section: 0)) as? MovieCollectionViewCell
    }
}
