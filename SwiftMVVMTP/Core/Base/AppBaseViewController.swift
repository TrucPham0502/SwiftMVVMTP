//
//  AppBaseViewController.swift
//  SwiftMVVMTP
//
//  Created by Truc Pham on 23/09/2021.
//

import Foundation
import RxSwift
import MBProgressHUD
import Alamofire
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
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
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
        case let err as AFError where err.isSessionTaskError:
            self.showToast(message: "Could not connect to the server.")
        default:
            self.showToast(message: error.localizedDescription)
        }
    }
    
    func hideKeyboard() {
        self.view.endEditing(true)
    }
    
    func naviagtionBack(_ animation : Bool = true, completion: (() -> Void)? = nil){
        if !self.isModal {
            self.navigationController?.popViewController(animated: animation)
            completion?()
        } else {
            self.dismiss(animated: animation, completion: completion)
        }
    }
    
    func deepLink(receive data : DeepLinkValues) { }
    
}
