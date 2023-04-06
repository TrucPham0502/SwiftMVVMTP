//
//  MovieCollectionView.swift
//  SwiftMVVMTP
//
//  Created by Truc Pham on 24/09/2021.
//

import Foundation
import UIKit

class MovieCollectionView: UICollectionView {
    init(_ view: UIView,
         layout: UICollectionViewLayout,
         height: CGFloat,
         dataSource: UICollectionViewDataSource,
         delegate: UICollectionViewDelegate){
        super.init(frame: .zero, collectionViewLayout: layout)
        self.decelerationRate = UIScrollView.DecelerationRate.fast
        self.showsHorizontalScrollIndicator = false
        self.dataSource = dataSource
        self.delegate = delegate
        self.backgroundColor = UIColor(white: 0, alpha: 0)
        self.register(MovieCollectionViewCell.self, forCellWithReuseIdentifier: String(describing: MovieCollectionViewCell.self))
        let tap = UITapGestureRecognizer(target: self, action: #selector(viewTap))
        self.addGestureRecognizer(tap)
    }
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: init

extension MovieCollectionView {
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
    @objc private func viewTap(_ sender : UIGestureRecognizer){
        if let currentCell = currentCell {
            let point = sender.location(in: currentCell)
            currentCell.handleTouch(point)
        }
    }
}
//extension MovieCollectionView : UIGestureRecognizerDelegate {
//    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
//
//    }
//}
