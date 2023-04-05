//
//  StretchyScrollView.swift
//  SwiftMVVMTP
//
//  Created by TrucPham on 05/04/2023.
//  Copyright © 2023 Truc Pham. All rights reserved.
//

import Foundation
import UIKit
protocol StretchyScrollViewDelegate : AnyObject {
    func stretchyScrollView(_ scrollView : UIScrollView, shouldRespond recognizer: UIPanGestureRecognizer, vel : CGPoint) -> Bool
    func stretchyScrollView(headerView scrollView : UIScrollView) -> UIView
    func stretchyScrollView(headerSize scrollView : UIScrollView) -> CGFloat
    func stretchyScrollView(minHeight scrollView : UIScrollView) -> CGFloat
    func stretchyScrollView(maxDragDown scrollView : UIScrollView) -> CGFloat
    func stretchyScrollView(maxDragUp scrollView : UIScrollView) -> CGFloat
    func stretchyScrollView(_ scrollView : UIScrollView, beganTranslate dy : CGFloat, velocity: CGPoint, viewHeight : CGFloat)
    func stretchyScrollView(_ scrollView : UIScrollView, translate dy : CGFloat, velocity: CGPoint, viewHeight : CGFloat)
    func stretchyScrollView(_ scrollView: UIScrollView, finishDragging dy: CGFloat, velocity: CGPoint, viewHeight : CGFloat)
}
extension StretchyScrollViewDelegate {
    func stretchyScrollView(_ scrollView : UIScrollView, shouldRespond recognizer: UIPanGestureRecognizer, vel : CGPoint) -> Bool {
        return true
    }
    func stretchyScrollView(minHeight scrollView : UIScrollView) -> CGFloat {
        return 0
    }
    func stretchyScrollView(maxDragDown scrollView : UIScrollView) -> CGFloat {
        return (stretchyScrollView(headerSize: scrollView) + stretchyScrollView(minHeight: scrollView)) / 3
    }
    func stretchyScrollView(maxDragUp scrollView : UIScrollView) -> CGFloat {
        return 2 * (stretchyScrollView(headerSize: scrollView) + stretchyScrollView(minHeight: scrollView)) / 3
    }
    func stretchyScrollView(_ scrollView : UIScrollView, beganTranslate dy : CGFloat, velocity: CGPoint, viewHeight : CGFloat) {
        
    }
    func stretchyScrollView(_ scrollView : UIScrollView, translate dy : CGFloat, velocity: CGPoint, viewHeight : CGFloat) {
        
    }
    func stretchyScrollView(_ scrollView: UIScrollView, finishDragging dy: CGFloat, velocity: CGPoint, viewHeight : CGFloat) {
        
    }

}
class StretchyScrollView {
    var isPull : Bool = true
    private var currentHeaderHeight : CGFloat = 0 {
        didSet{
            guard let view = self.delegate?.stretchyScrollView(headerView: scrollView) else { return }
            if view.translatesAutoresizingMaskIntoConstraints {
                view.frame.size.height = self.currentHeaderHeight
            }
            else { view.getConstraint(.height)?.constant = self.currentHeaderHeight }
        }
    }
    private var originalHeight: CGFloat {
        return delegate?.stretchyScrollView(headerSize: scrollView) ?? 0
    }
    private var minHeight: CGFloat {
        return delegate?.stretchyScrollView(minHeight: scrollView) ?? 0
    }
    let scrollView : UIScrollView
    weak var delegate: StretchyScrollViewDelegate?
    var lastY : CGFloat = 0
    private var lastContentOffset: CGPoint = .zero
    init(scrollView : UIScrollView, delegate: StretchyScrollViewDelegate?) {
        self.scrollView = scrollView
        self.delegate = delegate
    }
    
    func startTracking(){
        self.currentHeaderHeight = self.delegate?.stretchyScrollView(headerSize: scrollView) ?? 0
        scrollView.panGestureRecognizer.addTarget(self, action: #selector(handleScrollPan(_:)))
    }
    
    
    @objc private func handleScrollPan(_ recognizer: UIPanGestureRecognizer) {
        let dy = recognizer.translation(in: recognizer.view).y
        let vel = recognizer.velocity(in: recognizer.view)
        let allow = self.delegate?.stretchyScrollView(scrollView, shouldRespond: recognizer, vel: vel) ?? true
        guard let scrollView = recognizer.view as? UIScrollView else {return}
        guard let view = delegate?.stretchyScrollView(headerView: scrollView) else {
            return
        }
        let height = view.getConstraint(.height)?.constant ?? view.frame.height
        switch recognizer.state {
        case .began:
            lastY = 0
            lastContentOffset.y = scrollView.contentOffset.y + dy
            delegate?.stretchyScrollView(scrollView, beganTranslate: dy, velocity: vel, viewHeight: height)
        case .changed:
            guard allow else { return }
            translate(with: vel, dy: dy, scrollView: scrollView)
        case .ended,
             .cancelled,
             .failed:
            guard allow else { return }
            let state = dragDirection(vel)
            switch state {
            case .up where height > minHeight:
                scrollView.setContentOffset(lastContentOffset, animated: false)
            default:
               break
            }
            self.finishDragging(state: state)
            delegate?.stretchyScrollView(scrollView, finishDragging: dy, velocity: vel, viewHeight: height)
        default:
            break
        }
    }
    private func finishDragging(state : DraggingState){
        guard let view = self.delegate?.stretchyScrollView(headerView: scrollView), let height = view.constraints.first(where: {
            $0.firstAttribute == .height
        }) else {
            return
        }
        var constant = self.originalHeight
        switch state {
        case .up:
            if currentHeaderHeight <= delegate?.stretchyScrollView(maxDragUp: scrollView) ?? minHeight  {
                constant = self.minHeight
            }
            else {
                constant = self.originalHeight
            }
        case  .down:
            if currentHeaderHeight >= delegate?.stretchyScrollView(maxDragDown: scrollView) ?? self.originalHeight  {
                constant =  self.originalHeight
            }
            else {
                constant = self.minHeight
            }
        case .idle:
            constant = currentHeaderHeight < self.originalHeight ? self.minHeight : self.originalHeight

        }
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.4, options: []) {
            height.constant = constant
        }
       
    }
    private func translate(with velocity: CGPoint, dy: CGFloat, scrollView: UIScrollView? = nil){
        if let scroll = scrollView{
            guard let view = delegate?.stretchyScrollView(headerView: self.scrollView) else {
                return
            }
            let height = view.getConstraint(.height)?.constant ?? view.frame.height
            switch dragDirection(velocity) {
            case .up where height > minHeight:
                let constant = dy - lastY
                var move = height + constant
                move = isPull ? move : (move > originalHeight ? originalHeight : move)
                self.currentHeaderHeight = max(move > 0 ? move  : 0, minHeight)
//                scroll.contentOffset.y = lastContentOffset.y
            case .down where scroll.contentOffset.y <= 0 && (isPull ||  height < originalHeight):
                var move =  height + (dy - lastY)
                move = isPull ? move : (move > originalHeight ? originalHeight : move)
                if move > self.originalHeight {
                    self.currentHeaderHeight = height + ((dy - lastY)/2)
                   
                }
                else { self.currentHeaderHeight =  move}
                scroll.contentOffset.y = 0
                lastContentOffset = .zero
            default:
                break
            }
            lastY = dy
            delegate?.stretchyScrollView(self.scrollView, translate: dy, velocity: velocity, viewHeight: height)
        }
    }
    private func dragDirection(_ velocity: CGPoint) -> DraggingState{
        if velocity.y < 0 {
            return .up
        }else if velocity.y > 0{
            return .down
        }else{
            return .idle
        }
    }
    private enum DraggingState{
        case up, down, idle
    }
}
