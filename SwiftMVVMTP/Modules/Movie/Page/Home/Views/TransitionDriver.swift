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
    fileprivate var backImageView: UIImageView?
    fileprivate var titleAttribute : NSAttributedString?
    

    fileprivate var leftCell: UICollectionViewCell?
    fileprivate var rightCell: UICollectionViewCell?
    fileprivate var step: CGFloat = 0

    fileprivate var frontViewFrame = CGRect.zero
    fileprivate var backViewFrame = CGRect.zero
    fileprivate var titleFrame = CGRect.zero

    init(view: UIView) {
        self.view = view
    }
}

// MARK: control

extension TransitionDriver {

    func pushTransitionAnimationIndex(_ currentIndex: Int,
                                      collecitionView: UICollectionView,
                                      backImage: UIImage?,
                                      headerHeight: CGFloat,
                                      insets: CGFloat,
                                      titleAttr : NSAttributedString,
                                      completion: @escaping () -> Void) {

        guard case let cell as MovieCollectionViewCell = collecitionView.cellForItem(at: IndexPath(row: currentIndex, section: 0)) else { return }
    
        guard let copyView = cell.copyCell(view: view) else {
            return
        }
        copyCell = copyView

        // move cells
        moveCellsCurrentIndex(currentIndex, collectionView: collecitionView)

        currentCell = cell
        cell.isHidden = true

        configurateCell(copyView, backImage: backImage)
        backImageView = addImageToView(copyView.backContainerView, image: backImage)

        openBackViewConfigureConstraints(copyView)
        openFrontViewConfigureConstraints(copyView)
        openTitleViewConfigureConstraints(copyView)
        

        // corner animation
        copyView.backContainerView.animationCornerRadius(0, duration: duration)
        copyView.frontContainerView.animationCornerRadius(0, duration: duration)
        copyView.center = view.center

        // constraints animation
        UIView.animate(withDuration: duration, delay: 0, options: UIView.AnimationOptions(), animations: {
            self.view.layoutIfNeeded()
            self.backImageView?.alpha = 1
            self.copyCell?.shadowView?.alpha = 0
            
        }, completion: { _ in
            completion()
        })
    }

    func popTransitionAnimationContantOffset(_ offset: CGFloat, backImage: UIImage?,completion: @escaping () -> Void) {
        guard let copyCell = self.copyCell else {
            return
        }

        backImageView?.image = backImage
        // configuration start position
        configureCellBeforeClose(copyCell, offset: offset)

        closeBackViewConfigurationConstraints(copyCell)
        closeFrontViewConfigurationConstraints(copyCell)

        
        
        // corner animation
        copyCell.backContainerView.animationCornerRadius(copyCell.backContainerView.layer.cornerRadius, duration: duration)
        copyCell.frontContainerView.animationCornerRadius(copyCell.frontContainerView.layer.cornerRadius, duration: duration)

        UIView.animate(withDuration: duration, delay: 0, options: UIView.AnimationOptions(), animations: {
            self.rightCell?.center.x -= self.step
            self.leftCell?.center.x += self.step

            self.view.layoutIfNeeded()
            self.backImageView?.alpha = 0
            copyCell.shadowView?.alpha = 1

        }, completion: { _ in
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

    fileprivate func configurateCell(_ cell: MovieCollectionViewCell, backImage _: UIImage?) {
        view.addSubview(cell)
        cell.backContainerView.backgroundColor = .clear
        cell.gradientLayer.isHidden = true
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame.size = view.bounds.size
        gradientLayer.colors = [UIColor.clear.cgColor, UIColor.black.withAlphaComponent(0.7).cgColor, UIColor.black.withAlphaComponent(0.8).cgColor,UIColor.black.cgColor, UIColor.black.cgColor, UIColor.black.cgColor, UIColor.black.cgColor]
        cell.backContainerView.layer.addSublayer(gradientLayer)
        cell.contentView.bringSubviewToFront(cell.backContainerView)
        cell.contentView.bringSubviewToFront(cell.customTitle)
        
        cell.customTitle.textAlignment = .left
        cell.customTitle.font = .boldSystemFont(ofSize: 20)
        
//       cell.translatesAutoresizingMaskIntoConstraints = false
        // add constraints
//        NSLayoutConstraint.activate([
//            cell.widthAnchor.constraint(equalToConstant: cell.bounds.size.width),
//            cell.heightAnchor.constraint(equalToConstant: cell.bounds.size.height),
//            cell.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//            cell.centerYAnchor.constraint(equalTo: view.centerYAnchor),
//        ])
//        cell.layoutIfNeeded()
       
    }

    fileprivate func addImageToView(_ view: UIView, image: UIImage?) -> UIImageView? {
        guard let image = image else { return nil }

        let imageView = UIImageView(image: image)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.alpha = 0
        
        view.addSubview(imageView)

        // add constraints
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            imageView.topAnchor.constraint(equalTo: view.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
        
        imageView.layoutIfNeeded()

        return imageView
    }

    fileprivate func moveCellsCurrentIndex(_ currentIndex: Int, collectionView: UICollectionView) {
        leftCell = nil
        rightCell = nil

        if let leftCell = collectionView.cellForItem(at: IndexPath(row: currentIndex - 1, section: 0)) {
            let step = leftCell.frame.size.width + (leftCell.frame.origin.x - collectionView.contentOffset.x)
            UIView.animate(withDuration: 0.2, animations: {
                leftCell.center.x -= step
            })
            self.leftCell = leftCell
            self.step = step
        }

        if let rightCell = collectionView.cellForItem(at: IndexPath(row: currentIndex + 1, section: 0)) {
            let step = collectionView.frame.size.width - (rightCell.frame.origin.x - collectionView.contentOffset.x)
            UIView.animate(withDuration: 0.2, animations: {
                rightCell.center.x += step
            })
            self.rightCell = rightCell
            self.step = step
        }
    }
}

// MARK: animations

extension TransitionDriver {

    fileprivate func openTitleViewConfigureConstraints(_ cell: MovieCollectionViewCell) {
        self.titleAttribute = cell.customTitle.attributedText
        self.titleFrame = cell.customTitle.frame
        if let widthfrontContainer = cell.frontConstraint.width {
            cell.titleConstraint.top?.constant = -250
            if let widthTitle = cell.titleConstraint.width {
                widthTitle.constant = widthfrontContainer.constant - 40
            }
        }
        
        
    }
    
    fileprivate func openFrontViewConfigureConstraints(_ cell: MovieCollectionViewCell) {
        guard let frontConstraintY = cell.frontConstraint.centerY else {
            return
        }
        let width = view.bounds.size.width
        let height = width * cell.frontContainerView.frame.height / cell.frontContainerView.frame.width
        if let heightConstraint = cell.frontConstraint.height {
            frontViewFrame.size.height = heightConstraint.constant
            heightConstraint.constant = height
        }
        
        if let widthConstraint = cell.frontConstraint.width {
            frontViewFrame.size.width = widthConstraint.constant
            widthConstraint.constant = width
        }

        frontViewFrame.origin.y = frontConstraintY.constant
        frontConstraintY.constant = -(view.bounds.size.height - height) / 2
       
    }

    fileprivate func openBackViewConfigureConstraints(_ cell: MovieCollectionViewCell) {
        guard let backConstraintY = cell.backConstraint.centerY else {
            return
        }
        
        let height = view.bounds.size.height
        let width = view.bounds.size.width
        if let heightConstraint = cell.backConstraint.height {
            backViewFrame.size.height = heightConstraint.constant
            heightConstraint.constant = height
        }

        if let widthConstraint = cell.backConstraint.width {
            backViewFrame.size.width = widthConstraint.constant
            widthConstraint.constant = width
        }

        backViewFrame.origin.y = backConstraintY.constant
        backConstraintY.constant = 0
        
    }

    fileprivate func closeBackViewConfigurationConstraints(_ cell: MovieCollectionViewCell?) {
        guard let cell = cell, let backConstraintY = cell.backConstraint.centerY else { return }

        let heightConstraint = cell.backContainerView.getConstraint(.height)
        heightConstraint?.constant = backViewFrame.size.height

        let widthConstraint = cell.backContainerView.getConstraint(.width)
        widthConstraint?.constant = backViewFrame.size.width

        backConstraintY.constant = backViewFrame.origin.y
    }

    fileprivate func closeTitleViewConfigurationConstraints(_ cell: MovieCollectionViewCell) {
        cell.customTitle.attributedText = self.titleAttribute
        cell.titleConstraint.bottom?.constant = self.titleFrame.origin.y - self.frontViewFrame.height
        if let leadingTitle = cell.customTitle.getConstraint(.leading) {
            leadingTitle.constant = self.titleFrame.origin.x
        }
        if let trailingTitle = cell.customTitle.getConstraint(.trailing) {
            trailingTitle.constant = -(self.frontViewFrame.size.width - self.titleFrame.size.width)
        }
    }
    
    fileprivate func closeFrontViewConfigurationConstraints(_ cell: MovieCollectionViewCell?) {
        guard let cell = cell, let frontConstraintY = cell.frontConstraint.centerY else { return }

        if let heightConstraint = cell.frontContainerView.getConstraint(.height) {
            heightConstraint.constant = frontViewFrame.size.height
        }

        if let widthConstraint = cell.frontContainerView.getConstraint(.width) {
            widthConstraint.constant = frontViewFrame.size.width
        }

        frontConstraintY.constant = frontViewFrame.origin.y
    }

    fileprivate func configureCellBeforeClose(_ cell: MovieCollectionViewCell, offset: CGFloat) {
        guard let frontConstraintY = cell.frontConstraint.centerY, let backConstraintY = cell.backConstraint.centerY else {
            return
        }
        frontConstraintY.constant -= offset
        backConstraintY.constant -= offset / 2.0
        if let heightConstraint = cell.backContainerView.getConstraint(.height) {
            heightConstraint.constant += offset
        }
        cell.contentView.layoutIfNeeded()
    }
}
