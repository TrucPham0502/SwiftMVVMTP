//
//  BaseViewController.swift
//  SwiftMVVMTP
//
//  Created by Truc Pham on 23/09/2021.
//

import Foundation
import RxSwift
import RxCocoa
class BaseViewController<VM : ViewModelElement> : AppBaseViewController {
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
    }
    func buildViewModel() -> VM {
        fatalError("can not found View Model of \(String(describing: type(of: self)))")
    }
    
    deinit {
        debugPrint("---------------\(String(describing: type(of: self))) disposed-------------")
    }
}
