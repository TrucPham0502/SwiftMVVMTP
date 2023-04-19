//
//  TransitionDriver.swift
//  SwiftMVVMTP
//
//  Created by Truc Pham on 25/09/2021.
//

import Foundation
import UIKit
class TransitionDriver {
    // MARK: Vars

    fileprivate let view: UIView
    fileprivate let duration: Double = 0.4
    
    // for push animation
    fileprivate var copyCell: MovieCollectionViewCell?
    fileprivate var currentCell: MovieCollectionViewCell?
    fileprivate let gradientLayer = CAGradientLayer()

    fileprivate var leftCell: UICollectionViewCell?
    fileprivate var rightCell: UICollectionViewCell?
    fileprivate var leftFrame: CGRect = .zero
    fileprivate var rightFrame: CGRect = .zero

    fileprivate var frontViewConstraint : SaveContraint = .init()
    fileprivate var backViewConstraint : SaveContraint = .init()
    fileprivate var viewFrame = CGRect.zero

    init(view: UIView) {
        self.view = view
        initGradientLayer()
    }
    
    func initGradientLayer(){
        gradientLayer.opacity = 0
        gradientLayer.frame = self.view.bounds
        self.view.layer.addSublayer(gradientLayer)
    }
}

// MARK: control

extension TransitionDriver {

    func pushTransitionAnimationIndex(_ currentIndex: Int,
                                      collecitionView: UICollectionView,
                                      imageSize: CGSize,
                                      gradientColors: [CGColor],
                                      completion: @escaping (MovieCollectionViewCell) -> Void) {

        guard case let cell as MovieCollectionViewCell = collecitionView.cellForItem(at: IndexPath(row: currentIndex, section: 0)) else { return }
    
        guard let copyView = cell.copyCell(view: view) else {
            return
        }
        copyCell = copyView
        // move cells
        moveCellsCurrentIndex(currentIndex, collectionView: collecitionView)

        currentCell = cell
        cell.isHidden = true
        
        configurateCell(copyView, gradientColors: gradientColors)
        openBackViewConfigureConstraints(copyView)
        openFrontViewConfigureConstraints(copyView, imageSize: imageSize)
        

        // corner animation
        copyView.backContainerView.animationCornerRadius(0, duration: duration)
        copyView.frontContainerView.animationCornerRadius(0, duration: duration)
        
      
        copyView.titleView.alpha = 0
        // constraints animation
        UIView.animate(withDuration: duration, delay: 0, options: UIView.AnimationOptions(), animations: {
            copyView.shadowView?.alpha = 0
            copyView.backContainerView.backgroundColor = .black
            self.gradientLayer.opacity = 1
            self.view.layoutIfNeeded()
            copyView.setNeedsLayout()
        }, completion: { _ in
            completion(copyView)
        })
    }

    func popTransitionAnimationContantOffset(_ offset: CGFloat, completion: @escaping () -> Void) {
        guard let copyCell = self.copyCell else {
            return
        }

        // configuration start position
        configureCellBeforeClose(copyCell, offset: offset)

        closeBackViewConfigurationConstraints(copyCell)
        closeFrontViewConfigurationConstraints(copyCell)
        // corner animation
        copyCell.backContainerView.animationCornerRadius(copyCell.backContainerView.layer.cornerRadius, duration: duration)
        copyCell.frontContainerView.animationCornerRadius(copyCell.frontContainerView.layer.cornerRadius, duration: duration)
        
        self.gradientLayer.opacity = 0
 
        UIView.animate(withDuration: duration, delay: 0, options: UIView.AnimationOptions(), animations: {
            copyCell.shadowView?.alpha = 1
            UIView.animate(withDuration: self.duration, delay: self.duration, options: UIView.AnimationOptions(), animations: {
                copyCell.titleView.alpha = 1
            })
            copyCell.backContainerView.backgroundColor = .white
            self.rightCell?.frame = self.rightFrame
            self.leftCell?.frame = self.leftFrame
            self.view.layoutIfNeeded()
            copyCell.layoutIfNeeded()
        }, completion: { _ in
            self.gradientLayer.removeFromSuperlayer()
            self.currentCell?.isHidden = false
            self.removeCurrentCell()
            completion()
        })
    }
}

// MARK: Helpers

extension TransitionDriver {

    fileprivate func removeCurrentCell() {
        if case let currentCell as UIView = copyCell {
            currentCell.removeFromSuperview()
        }
    }

    fileprivate func configurateCell(_ cell: MovieCollectionViewCell, gradientColors : [CGColor]) {
        view.addSubview(cell)
        viewFrame = cell.frame
        cell.center = view.center
        gradientLayer.removeFromSuperlayer()
        gradientLayer.colors = gradientColors
        view.layer.addSublayer(gradientLayer)
    }

    fileprivate func moveCellsCurrentIndex(_ currentIndex: Int, collectionView: UICollectionView) {
        leftCell = nil
        rightCell = nil

        if let leftCell = collectionView.cellForItem(at: IndexPath(row: currentIndex - 1, section: 0)) {
            let step = leftCell.frame.size.width + (leftCell.frame.origin.x - collectionView.contentOffset.x)
            self.leftFrame = leftCell.frame
            UIView.animate(withDuration: 0.2, animations: {
                leftCell.center.x -= step
            })
            self.leftCell = leftCell
        }

        if let rightCell = collectionView.cellForItem(at: IndexPath(row: currentIndex + 1, section: 0)) {
            let step = collectionView.frame.size.width - (rightCell.frame.origin.x - collectionView.contentOffset.x)
            self.rightFrame = rightCell.frame
            UIView.animate(withDuration: 0.2, animations: {
                rightCell.center.x += step
            })
            self.rightCell = rightCell
        }
    }
}

// MARK: animations

extension TransitionDriver {
    
    fileprivate func openFrontViewConfigureConstraints(_ cell: MovieCollectionViewCell, imageSize : CGSize) {
        self.frontViewConstraint = SaveContraint(cell.frontConstraint)
        guard let frontConstraintY = cell.frontConstraint.centerY else {
            return
        }
        let width = view.bounds.size.width
        let height = width * imageSize.height / imageSize.width
        if let heightConstraint = cell.frontConstraint.height {
            heightConstraint.constant = height
        }
        
        if let widthConstraint = cell.frontConstraint.width {
            widthConstraint.constant = width
        }
        
        frontConstraintY.constant = -(view.bounds.size.height - height) / 2
       
    }

    fileprivate func openBackViewConfigureConstraints(_ cell: MovieCollectionViewCell) {
        self.backViewConstraint = SaveContraint(cell.backConstraint)
        guard let backConstraintY = cell.backConstraint.centerY else {
            return
        }
        
        let height = view.bounds.size.height
        let width = view.bounds.size.width
        if let heightConstraint = cell.backConstraint.height {
            heightConstraint.constant = height
        }

        if let widthConstraint = cell.backConstraint.width {
            widthConstraint.constant = width
        }
        backConstraintY.constant = 0
        
    }

    fileprivate func closeBackViewConfigurationConstraints(_ cell: MovieCollectionViewCell?) {
        guard let cell = cell else { return }
        if let heightConstraint = self.backViewConstraint.height {
            cell.backConstraint.height?.constant = heightConstraint
        }
        if let widthConstraint = self.backViewConstraint.width {
            cell.backConstraint.width?.constant = widthConstraint
        }
        if let centerYConstraint = self.backViewConstraint.centerY {
            cell.backConstraint.centerY?.constant = centerYConstraint
        }
    }
    
    fileprivate func closeFrontViewConfigurationConstraints(_ cell: MovieCollectionViewCell?) {
        guard let cell = cell else { return }

        if let heightConstraint = self.frontViewConstraint.height {
            cell.frontConstraint.height?.constant = heightConstraint
        }
        
        if let widthConstraint = self.frontViewConstraint.width {
            cell.frontConstraint.width?.constant = widthConstraint
        }
        
        if let centerYConstraint = self.frontViewConstraint.centerY {
            cell.frontConstraint.centerY?.constant = centerYConstraint
        }
    }

    fileprivate func configureCellBeforeClose(_ cell: MovieCollectionViewCell, offset: CGFloat) {
        cell.frame = viewFrame
       
        guard let frontConstraintY = cell.frontConstraint.centerY, let backConstraintY = cell.backConstraint.centerY else {
            return
        }
        frontConstraintY.constant -= offset
        backConstraintY.constant -= offset / 2.0
        if let heightConstraint = cell.backConstraint.height {
            heightConstraint.constant += offset
        }
        cell.contentView.layoutIfNeeded()
    }
}
