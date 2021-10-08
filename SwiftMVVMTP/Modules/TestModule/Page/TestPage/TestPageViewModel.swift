//
//  TestPageViewModel.swift
//  SwiftMVVMTP
//
//  Created by Truc Pham on 23/09/2021.
//

import Foundation
import RxSwift
import RxCocoa
class TestPageViewModel : BaseViewModel<TestPageViewModel.Input, TestPageViewModel.Output> {
    @Dependency.Inject
    var service : TestModuleService
    
    @BehaviorRelayProperty(value: "123")
    var textSearch: String
    
    @BehaviorRelayProperty(value: [])
    var items : [TestCellModel]
    
    struct Input  {
        var viewWillAppear: Driver<Void>
        var textSearch : ControlProperty<String>
    }
    struct Output {
        let items: Driver<[TestCellModel]>
    }
    
    
    override func transform(input: Input) -> Output {
        (input.textSearch <-> self.$textSearch).disposed(by: self.disposeBag)
        self.$textSearch.map({
            print($0)
        }).asDriverOnErrorJustComplete().drive().disposed(by: self.disposeBag)
        
        
        input.viewWillAppear.flatMap({[weak self] _ in
            guard let _self = self else { return Driver.just([])}
            return Observable.deferred { [unowned self] () ->  Observable<[TestCellModel]> in
                return _self.service.getDataTest(.init())
            }.trackActivity(_self.activityIndicator)
                .trackError(_self.errorTracker)
                .asDriverOnErrorJustComplete()
        }).drive(self.$items).disposed(by: self.disposeBag)
        
        return Output(items: self.$items.asDriverOnErrorJustComplete())
    }
    
}

