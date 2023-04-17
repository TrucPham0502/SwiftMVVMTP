//
//  BaseViewController.swift
//  SwiftMVVMTP
//
//  Created by Truc Pham on 23/09/2021.
//

import Foundation
import RxSwift
import RxCocoa
class BaseViewController<VM : ViewModelType> : AppBaseViewController {
    private var fetching: Driver<Bool>?
    var viewModel: VM!
    func performBinding() {
        viewModel.activityIndicator.asDriver()
            .drive(onNext: { [unowned self] in self.showLoading(withStatus: $0) })
            .disposed(by: self.disposeBag)
        viewModel.errorTracker.asDriver()
            .drive(onNext: { [unowned self] in self.handleError(error: $0) })
            .disposed(by: self.disposeBag)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel = buildViewModel()
        self.performBinding()
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        NotificationCenter.default.addObserver(self, selector: #selector(playerLoading), name: .playerLoading, object: nil)
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    override func handleError(error: Error) {
        switch error {
        case is ApiError:
            let error = (error as! ApiError)
            switch error.errorCode {
            case ErrorCode.sessionExpired:
                showToast(message: error.errorMessage, complete: { _ in
                    AppData.logout()
                    let vc = SplashScreenViewController()
                    vc.modalPresentationStyle = .fullScreen
                    if let app = UIApplication.shared.delegate as? AppDelegate {
                        app.window?.rootViewController = UINavigationController(rootViewController: vc)
                    }
                })
            default: super.handleError(error: error)
            }
        case is AppError:
            let error = (error as! AppError)
            switch error.errorCode {
            case ErrorCode.sessionExpired:
                showToast(message: error.errorMessage, complete: { _ in
                    let vc = LoginViewController()
                    self.present(vc, animated: true, completion: nil)
                })
            default: super.handleError(error: error)
            }
        default:  super.handleError(error: error)
        }
       
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    func buildViewModel() -> VM {
        fatalError("can not found View Model of \(String(describing: type(of: self)))")
    }
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    @objc private func playerLoading(_ sender : Notification) {
        if let isloading = sender.object as? Bool {
            self.showLoading(withStatus: isloading)
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
        debugPrint("---------------\(String(describing: type(of: self))) disposed-------------")
    }
}




