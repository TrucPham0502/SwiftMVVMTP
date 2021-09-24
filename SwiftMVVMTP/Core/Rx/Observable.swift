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
    func on(_ event: Event<Element>) { fatalError() }
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
class ObservableProperty<Element>: ObservableType {
    var wrappedValue: Element {
        didSet {
            subject.onNext(wrappedValue)
        }
    }
    
    private let subject: BehaviorSubject<Element>
    
    init(wrappedValue: Element) {
        self.wrappedValue = wrappedValue
        self.subject = BehaviorSubject<Element>(value: wrappedValue)
    }
    
    var projectedValue: Observable<Element> {
        return subject.asObservable()
    }
    
    func subscribe<Observer>(_ observer: Observer) -> Disposable where Observer : ObserverType, Element == Observer.Element {
        return subject.subscribe(observer)
    }
}
