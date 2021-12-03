//
//  File.swift
//  SwiftMVVMTP
//
//  Created by Truc Pham on 23/09/2021.
//

import Foundation
import RxSwift
import RxCocoa

protocol ViewModelType {
    associatedtype Input
    associatedtype Output
    var activityIndicator : ActivityIndicator { get }
    var errorTracker: ErrorTracker { get }
    func transform(input: Input) -> Output
}

class BaseViewModel<Input, Output> : NSObject, ViewModelType {
    let activityIndicator = ActivityIndicator()
    let errorTracker = ErrorTracker()
    let disposeBag = DisposeBag()
    
    func transform(input: Input) -> Output {
        var o: Output!
        return o
    }
    
    deinit {
        debugPrint("-------------------\(String(describing: type(of: self))) disposed--------------------")
    }
    
}

