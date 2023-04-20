//
//  URL+Extensions.swift
//  SwiftMVVMTP
//
//  Created by Truc Pham on 20/04/2023.
//  Copyright © 2023 Truc Pham. All rights reserved.
//

import Foundation
import RxSwift
extension URL {
    var getContent : Observable<String> {
        if self.isFileURL { return Observable.just("") }
        else {
            return Observable.create { sub in
                let task = URLSession.shared.dataTask(with: self) { data, response, error in
                    if let error = error {
                        sub.onError(error)
                        return
                    }
                    
                    guard let httpResponse = response as? HTTPURLResponse, (200..<300).contains(httpResponse.statusCode) else {
                        sub.onError(NSError(domain: "", code: 101, userInfo: [NSLocalizedDescriptionKey: "HTTP Error"]))
                        return
                    }
                    
                    guard let data = data, let bodyString = String(data: data, encoding: .utf8) else {
                        sub.onError(NSError(domain: "", code: 102, userInfo: [NSLocalizedDescriptionKey: "Data conversion error"]))
                        return
                    }
                    
                    sub.onNext(bodyString)
                }
                
                task.resume()
                return Disposables.create {
                    task.cancel()
                    sub.onCompleted()
                }
            }
        }
    }
}

