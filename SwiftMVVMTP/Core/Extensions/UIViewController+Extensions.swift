//
//  UIViewController+Extensions.swift
//  SwiftMVVMTP
//
//  Created by TrucPham on 13/04/2023.
//  Copyright © 2023 Truc Pham. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController{
    func ub_add(_ child: UIViewController, in container: UIView, animated: Bool = true, topInset: CGFloat, completion: (()->Void)? = nil) {
        addChild(child)
        container.addSubview(child.view)
        child.didMove(toParent: self)
        let f = CGRect(x: view.frame.minX, y: view.frame.minY, width: view.frame.width, height: view.frame.maxY - topInset)
        if animated{
            container.frame = f.offsetBy(dx: 0, dy: f.height)
            child.view.frame = container.bounds
            UIView.animate(withDuration: 0.3, animations: {
                container.frame = f
            }) { (_) in
                completion?()
            }
        }else{
            container.frame = f
            child.view.frame = container.bounds
            completion?()
        }
        
    }
    var isModal: Bool {
        let presentingIsModal = presentingViewController != nil
        let presentingIsNavigation = navigationController?.presentingViewController?.presentedViewController == navigationController
        let presentingIsTabBar = tabBarController?.presentingViewController is UITabBarController
        
        return presentingIsModal || presentingIsNavigation || presentingIsTabBar
    }
    func ub_remove() {
        willMove(toParent: nil)
        view.removeFromSuperview()
        removeFromParent()
    }
}
