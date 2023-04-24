//
//  ActivityIndicator.swift
//  SwiftMVVMTP
//
//  Created by Truc Pham on 23/09/2021.
//

import Foundation
import RxSwift
import RxCocoa
class ActivityIndicator: SharedSequenceConvertibleType {
    enum ActivityIndicatorStatus : Equatable {
        case loading(String)
        case none
    }
    public typealias Element = ActivityIndicatorStatus
    public typealias SharingStrategy = DriverSharingStrategy

    private let _lock = NSRecursiveLock()
    private let _variable = BehaviorRelay(value: ActivityIndicatorStatus.none)
    private let _loading: SharedSequence<SharingStrategy, ActivityIndicatorStatus>

    public init() {
        _loading = _variable.asDriver()
            .distinctUntilChanged()
    }

    fileprivate func trackActivityOfObservable<O: ObservableConvertibleType>(_ source: O, message: String) -> Observable<O.Element> {
        return source.asObservable()
            .do(onNext: { _ in
                self.sendStopLoading()
            }, onError: { _ in
                self.sendStopLoading()
            }, onCompleted: {
                self.sendStopLoading()
            }, onSubscribe: {
                self.subscribed(message)
            })
    }

    private func subscribed(_ message: String) {
        _lock.lock()
        _variable.accept(.loading(message))
        _lock.unlock()
    }

    private func sendStopLoading() {
        _lock.lock()
        _variable.accept(.none)
        _lock.unlock()
    }

    public func asSharedSequence() -> SharedSequence<SharingStrategy, Element> {
        return _loading
    }
}

extension ObservableConvertibleType {
    func trackActivity(_ activityIndicator: ActivityIndicator, message: String = "Loading...") -> Observable<Element> {
        return activityIndicator.trackActivityOfObservable(self, message: message)
    }
}
