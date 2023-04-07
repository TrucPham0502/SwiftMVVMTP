//
//  Observable.swift
//  SwiftMVVMTP
//
//  Created by Truc Pham on 23/09/2021.
//

import Foundation
import RxSwift
import RxCocoa
extension SharedSequenceConvertibleType {
    func mapToVoid() -> SharedSequence<SharingStrategy, Void> {
        return map { _ in }
    }
}
extension ObservableType {
    func asDriverOnErrorJustComplete() -> Driver<Element> {
        return asDriver { error in
            print("Error \(error)")
            return Driver.empty()
        }
    }
    
    func mapToVoid() -> Observable<Void> {
        return map { _ in }
    }
    
    
}

class WrapperSubject<Element>: ObservableType, ObserverType {
    func subscribe<Observer>(_ observer: Observer) -> Disposable where Observer : ObserverType, Element == Observer.Element { fatalError() }
    func on(_ event: Event<Element >) { fatalError() }
}
@propertyWrapper
class  BehaviorRelayProperty<Element>: WrapperSubject<Element> {
    var wrappedValue: Element {
        didSet {
            subject.onNext(wrappedValue)
        }
    }
    
    private let subject: BehaviorSubject<Element>
    init(value: Element) {
        self.wrappedValue = value
        self.subject = BehaviorSubject(value: wrappedValue)
    }
    
    
    
    var projectedValue: WrapperSubject<Element> {
        return self
    }
    
    
    
    override func subscribe<Observer>(_ observer: Observer) -> Disposable where Observer : ObserverType, Element == Observer.Element {
        return subject.subscribe(observer)
    }
    
    override func on(_ event: Event<Element>) {
        switch event {
        case .next(let element):
            wrappedValue = element
        default:
            break
        }
    }
}


@propertyWrapper
struct Proxy<EnclosingType, Value> {
    typealias ValueKeyPath = ReferenceWritableKeyPath<EnclosingType, Value>
    typealias SelfKeyPath = ReferenceWritableKeyPath<EnclosingType, Self>
    
    static subscript(
        _enclosingInstance instance: EnclosingType,
        wrapped wrappedKeyPath: ValueKeyPath,
        storage storageKeyPath: SelfKeyPath
    ) -> Value {
        get {
            let keyPath = instance[keyPath: storageKeyPath].keyPath
            return instance[keyPath: keyPath]
        }
        set {
            let keyPath = instance[keyPath: storageKeyPath].keyPath
            instance[keyPath: keyPath] = newValue
        }
    }
    
    @available(*, unavailable,
                message: "@Proxy can only be applied to classes"
    )
    var wrappedValue: Value {
        get { fatalError() }
        set { fatalError() }
    }
    
    private let keyPath: ValueKeyPath
    
    init(_ keyPath: ValueKeyPath) {
        self.keyPath = keyPath
    }
}


extension ObservableConvertibleType where Element : ApiResponseDtoType  {
    func valid() -> Observable<Element.Element> {
        return self.asObservable().flatMap{data -> Observable<Element.Element> in
            if data.status == .success {
                return Observable.just(data.data)
            }
            return Observable.error(ApiError(parseClass: String(describing: self), errorMessage: data.message, errorCode: data.status.rawValue))
        }
    }
}



