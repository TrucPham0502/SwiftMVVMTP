//
//  BaseRepository.swift
//  SwiftMVVMTP
//
//  Created by Truc Pham on 25/09/2021.
//

import Foundation
import RxSwift
class BaseRepository : NSObject{
    func unwrap<T>(_ data : ApiResponseDto<T>) -> Observable<T?> {
        if data.returnCode == .success {
            return Observable.just(data.data)
        }
        return Observable.error(ApiError(parseClass: String(describing: self), errorMessage: data.returnMessage, errorCode: data.returnCode?.rawValue))
    }
}
