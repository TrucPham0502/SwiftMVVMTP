//
//  AppBaseViewController.swift
//  SwiftMVVMTP
//
//  Created by Truc Pham on 23/09/2021.
//

import Foundation
import RxSwift
import MBProgressHUD
class AppBaseViewController: UIViewController {
    
    let disposeBag = DisposeBag()
    
    public var isRootVC: Bool {
        return false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareUI()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.tabBarController?.tabBar.isHidden = !self.isRootVC
    }
    
    func prepareUI() {
    }
    
    func showToast(message: String) {
//        self.view.makeToast(message, duration: 3.0, position: .bottom)
    }
    
    func showLoading(withStatus show: Bool) {
        if show {
            let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
            hud.mode = .indeterminate
            hud.label.text = "Loading"
            hud.label.font = UIFont.systemFont(ofSize: 14)
            hud.hide(animated: true, afterDelay: 30)
        } else {
            MBProgressHUD.hide(for: self.view, animated: true)
        }
    }

    func handleError(error: Error) {
        self.displayError(error: error)
    }
    
    func displayError(error: Error) {
        switch error {
//        case is Four01HTTPError: // Unauthorized error
//            self.showToast(message: "unauthorized".localized)
            
        case let err as ApiError:
            self.showToast(message: err.errorMessage)
            
//        case let err as ParseDataError:
//            self.showToast(message: err.errorMessage.localized)
//
//        case let err as ValidateError where !err.message.isEmpty:
//            self.showToast(message: err.message)
            
        default:
            self.showToast(message: error.localizedDescription)
        }
    }
    
    func hideKeyboard() {
        self.view.endEditing(true)
    }
    
}
