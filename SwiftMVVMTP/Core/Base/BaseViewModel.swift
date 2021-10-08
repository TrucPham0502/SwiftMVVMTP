//
//  File.swift
//  SwiftMVVMTP
//
//  Created by Truc Pham on 23/09/2021.
//

import Foundation
import RxSwift
import RxCocoa

protocol ViewModelElement {
    var activityIndicator : ActivityIndicator { get }
    var errorTracker: ErrorTracker { get }
   
}

class BaseViewModel<I, O> : NSObject, ViewModelElement {
    let activityIndicator = ActivityIndicator()
    let errorTracker = ErrorTracker()
    let disposeBag = DisposeBag()
    
    public func transform(input: I) -> O {
        var o: O!
        return o
    }
    
    deinit {
        debugPrint("-------------------\(String(describing: type(of: self))) disposed--------------------")
    }
    
}

