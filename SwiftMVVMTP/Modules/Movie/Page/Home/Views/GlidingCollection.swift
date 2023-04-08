//
//  GlidingCollection.swift
//  SwiftMVVMTP
//
//  Created by Truc Pham on 25/09/2021.
//

import Foundation
import Foundation
import UIKit

class GlidingCollection: UIView {
    var delegate: GlidingCollectionDelegate?
    var dataSource: GlidingCollectionDatasource? {
        didSet {
            setupVerticalStack()
        }
    }
    var expandedItemIndex = 0 {
        didSet {
//            guard let count = dataSource?.numberOfItems(in: self) else { return }
            containerView.isScrollEnabled = false//expandedItemIndex == 0 || expandedItemIndex == count - 1
        }
    }
    
    var collectionView: MovieCollectionView
    
    // MARK: Private properties
    fileprivate var containerView = UIScrollView()
    fileprivate var scaledTransform: CGAffineTransform {
        let scale = config.buttonsScaleFactor
        return CGAffineTransform(scaleX: scale, y: scale)
    }
    fileprivate var config: UIMovieHomeConfig {
        return UIMovieHomeConfig.shared
    }
    
    // Gesture related properties.
    fileprivate var gesture: UIPanGestureRecognizer!
    fileprivate var gestureStartPosition: CGPoint = .zero
    fileprivate enum Direction {
        case up, down
    }
    fileprivate var lastDirection = Direction.down
    fileprivate var lastExpandedItemIndex = 0
    fileprivate var topViews: [UIButton] = []
    fileprivate var bottomViews: [UIButton] = []
    
    // MARK: Snapshots
    fileprivate var newRightSideSnapshot: UIView?
    
    // MARK: Constructor 🏗
    /// :nodoc:
    override  init(frame: CGRect) {
        self.collectionView = MovieCollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
        super.init(frame: frame)
        commonInit()
    }
    
    init(collectionView : MovieCollectionView){
        self.collectionView = collectionView
        super.init(frame: .zero)
        commonInit()
    }
    
    /// :nodoc:
    required  init?(coder aDecoder: NSCoder) {
        self.collectionView = MovieCollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        setup()
        animateTopButtons()
        animateBottomButtons()
    }
    
}

// MARK: - Lifecycle 🌎
extension GlidingCollection: UIGestureRecognizerDelegate {
    
    /// :nodoc:
    override func layoutSubviews() {
        super.layoutSubviews()
        containerView.frame = bounds
        containerView.contentSize = bounds.size
        containerView.showsVerticalScrollIndicator = false
        containerView.showsHorizontalScrollIndicator = false
        let cardSize = config.cardsSize
        let cardHeight = cardSize.height + 2*(cardSize.height/6 - CGFloat(UIMovieHomeConfig.shared.yOffsetItem/2)) + UIMovieHomeConfig.shared.yOffsetItem
        collectionView.frame = CGRect(x: 0, y: bounds.height/2 - cardHeight/2, width: bounds.width, height: cardHeight)
        
        animateTopButtons()
        animateBottomButtons()
    }
    
    /// :nodoc:
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        if otherGestureRecognizer === containerView.panGestureRecognizer {
            return true
        }
        return false
    }
    
}

// MARK: - Setup ⛏
fileprivate extension GlidingCollection {
    
    func setup() {
        setupContainerView()
        setupCollectionView()
        setupVerticalStack()
        setupPanGesture()
    }
    
    
    private func setupContainerView() {
        addSubview(containerView)
        containerView.alwaysBounceVertical = true
        containerView.delegate = self
    }
    
    private func setupCollectionView() {
        containerView.insertSubview(collectionView, at: 0)
    }
    
    func setupVerticalStack() {
        guard
            let source = dataSource,
            source.numberOfItems(in: self) > 0 else {
                return
            }
        
        for i in 0..<source.numberOfItems(in: self) {
            let isTopTitle = i <= expandedItemIndex
            let title = source.glidingCollection(self, itemAtIndex: i).uppercased()
            
            let button = UIButton()
            button.contentHorizontalAlignment = .left
            
            let color = isTopTitle ? config.activeButtonColor : config.inactiveButtonsColor
            button.setTitleColor(color, for: .normal)
            button.setTitle(title, for: .normal)
            button.titleLabel?.font = config.buttonsFont
            button.layer.anchorPoint = CGPoint(x: 0, y: 0)
            button.transform = scaledTransform
            
            isTopTitle ? topViews.append(button) : bottomViews.append(button)
            containerView.insertSubview(button, at: 0)
            button.addTarget(self, action: #selector(didTapped(_:)), for: .touchUpInside)
        }
        
    }
    
    
    private func setupPanGesture() {
        gesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
        gesture.delegate = self
        addGestureRecognizer(gesture)
    }
    
}

// MARK: - Actions ⚡
extension GlidingCollection {
    func expand(at index: Int, animated: Bool = true) {
        guard
            index != expandedItemIndex,
            let source = dataSource,
            index < source.numberOfItems(in: self), index >= 0 else {
                return
            }
        
        delegate?.glidingCollection(self, willExpandItemAt: index)
        
        
        let duration: Double = config.animationDuration
        let direction: Direction = index > expandedItemIndex ? .up : .down
        let up = direction == .up
        let bounds = self.bounds
        lastDirection = direction
        let unified = topViews + bottomViews
        let movingItem = unified[safe: index]
        topViews = Array(unified.prefix(through: index))
        bottomViews = index + 1 < unified.count ? Array(unified.suffix(from: index + 1)) : []
        
        var _rightCell : UICollectionViewCell? = nil
        var _leftCell : UICollectionViewCell? = nil
        
        var _rightStep : CGFloat = 0
        var _leftStep : CGFloat = 0
        
        
        if let leftCell = collectionView.cellForItem(at: IndexPath(row: collectionView.currentIndex - 1, section: 0)){
            let step = leftCell.frame.size.width + (leftCell.frame.origin.x - collectionView.contentOffset.x)
            _leftCell = leftCell
            _leftStep = step
        }
        
        
        if let rightCell = collectionView.cellForItem(at: IndexPath(row: collectionView.currentIndex + 1, section: 0)) {
            let step = collectionView.frame.size.width - (rightCell.frame.origin.x - collectionView.contentOffset.x)
            _rightCell = rightCell
            _rightStep = step
        }
        
        
        
        UIView.animate(withDuration: duration, animations: {
            _leftCell?.center.x -= _leftStep
            _rightCell?.center.x += _rightStep
        }, completion: {_ in
            UIView.animate(withDuration: duration) {
                self.collectionView.performBatchUpdates {
                    self.collectionView.reloadData()
                }
            }
        })
        
        
        
        
        // Set new expanded index
        let oldIndex = expandedItemIndex
        expandedItemIndex = index
        
        
        
        // MARK: Animate buttons
        UIView.animate(withDuration: duration, delay: 0, options: .curveEaseInOut, animations: {
            up ? self.animateBottomButtons() : self.animateTopButtons()
        }, completion: nil)
        if up, let movingButton = unified[safe: index], abs(oldIndex - index) <= 1 {
            UIView.animate(withDuration: duration, delay: 0, options: UIView.AnimationOptions.curveEaseInOut, animations: {
                if up {
                    let insets = self.config.sideInsets
                    movingButton.frame = CGRect(x: insets.left, y: self.collectionView.frame.minY - 40, width: bounds.width - insets.left - insets.right, height: 30)
                }
            }, completion: nil)
            
            UIView.animate(withDuration: duration, delay: 0, options: UIView.AnimationOptions.curveEaseInOut, animations: {
                self.animateTopButtons()
            }, completion: nil)
        } else {
            UIView.animate(withDuration: duration, delay: 0, options: UIView.AnimationOptions.curveEaseInOut, animations: {
                up ? self.animateTopButtons() : self.animateBottomButtons()
            }, completion: nil)
        }
        
        // MARK: Animate buttons textColor
        for button in unified {
            UIView.transition(with: button, duration: duration/2, options: UIView.AnimationOptions.transitionCrossDissolve, animations: {
                let color = button === movingItem ? self.config.activeButtonColor : self.config.inactiveButtonsColor
                button.setTitleColor(color, for: UIControl.State.normal)
            }, completion: nil)
        }
    }
    
    /// Expand next item in list
    func expandNext() {
        let index = expandedItemIndex + 1
        if let dataSource = self.dataSource, index < dataSource.numberOfItems(in: self), index > -1 {
            delegate?.glidingCollection(self, didSelectItemAt: index)
            expand(at: index)
            delegate?.glidingCollection(self, didExpandItemAt: index)
        }
        
    }
    
    /// Expand previous item in list
    func expandPrevious() {
        let index = expandedItemIndex - 1
        if let dataSource = self.dataSource, index < dataSource.numberOfItems(in: self), index > -1 {
            delegate?.glidingCollection(self, didSelectItemAt: index)
            expand(at: index)
            delegate?.glidingCollection(self, didExpandItemAt: index)
        }
        
    }
    
    func reloadData() {
        for button in topViews + bottomViews {
            button.removeFromSuperview()
        }
        topViews = []
        bottomViews = []
        setupVerticalStack()
        setNeedsLayout()
        layoutIfNeeded()
    }
    
    // MARK: Private
    @objc fileprivate func didTapped(_ button: UIButton) {
        let unifiedButtons = topViews + bottomViews
        guard let index = unifiedButtons.firstIndex(of: button) else { return }
        delegate?.glidingCollection(self, didSelectItemAt: index)
        expand(at: index)
        delegate?.glidingCollection(self, didExpandItemAt: index)
    }
    
    fileprivate func resetViews() {
        // Remove temporary layer
        newRightSideSnapshot = nil
        
        // Set new index to temporary property
        lastExpandedItemIndex = expandedItemIndex
    }
    
    
    @objc fileprivate func handlePanGesture(_ gesture: UIPanGestureRecognizer) {
        let location = gesture.location(in: self)
        let velocity = gesture.velocity(in: self)
        
        switch gesture.state {
        case .began:
            gestureStartPosition = location
            
        case .changed:
            guard containerView.contentOffset.y == 0 else { break }
            
            let up = location.y > gestureStartPosition.y
            let range = abs(location.y - gestureStartPosition.y)
            
            if range > 100 || abs(velocity.y) > 300 && abs(velocity.x) < 300 {
                up ? self.expandPrevious() : self.expandNext()
                gesture.isEnabled = false
                gesture.isEnabled = true
            }
        default: break
        }
        
    }
    
}

extension GlidingCollection: CAAnimationDelegate {
    
    fileprivate func animateTopButtons() {
        let buttonHeight = config.buttonsFont.pointSize * 1.2
        var minY = collectionView.frame.minY - buttonHeight
        let insets = config.sideInsets
        var topFrame = CGRect(x: insets.left, y: 0, width: bounds.width - insets.left - insets.right, height: buttonHeight)
        for button in topViews.reversed() {
            if button === topViews.last {
                button.transform = .identity
            } else {
                button.transform = scaledTransform
            }
            topFrame.origin.y = minY - config.buttonsSpacing
            button.frame = topFrame
            minY -= buttonHeight + config.buttonsSpacing
        }
    }
    
    fileprivate func animateBottomButtons() {
        var maxY = collectionView.frame.maxY
        let insets = config.sideInsets
        let buttonHeight = config.buttonsFont.pointSize * 1.2
        var topFrame = CGRect(x: insets.left, y: 0, width: bounds.width - insets.left - insets.right, height: buttonHeight)
        for button in bottomViews {
            button.transform = scaledTransform
            topFrame.origin.y = maxY + config.buttonsSpacing
            button.frame = topFrame
            maxY = button.frame.maxY
        }
    }
    
}

// MARK: - ScrollView Delegate
extension GlidingCollection: UIScrollViewDelegate {
    
    /// Must call super if you override this method.
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        guard let count = dataSource?.numberOfItems(in: self), expandedItemIndex == 0 || expandedItemIndex == count - 1 else { return }
        let top = expandedItemIndex == 0
        let y = scrollView.contentOffset.y
        let condition = top ? y > 0 : y < 0
        if condition {
            scrollView.contentOffset.y = 0
        }
    }
    
}
