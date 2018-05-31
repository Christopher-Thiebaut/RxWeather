//
//  RestApi.swift
//  RxWeather
//
//  Created by Christopher Thiebaut on 5/30/18.
//  Copyright © 2018 Christopher Thiebaut. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

protocol RestApi: class {

    var session:  URLSessionProtocol { get }
    var baseURL: URL { get }
    init(session: URLSessionProtocol)
    func makeDataRequest(_ request: ApiRequest) -> Observable<Data>
}

extension RestApi {
    
    func makeDataRequest(_ request: ApiRequest) -> Observable<Data> {
        return Observable.create({[unowned self] (observer) -> Disposable in
            guard  let urlRequest = request.urlRequest(with: self.baseURL) else {
                observer.onError(ApiError.InvalidRequestError("The provided ApiRequest cannot be translated into a valid query."))
                return Disposables.create()
            }
            let networkRequest = self.session.dataTask(with: urlRequest, completionHandler: { (data, urlResponse, error) in
                guard error == nil else {
                    observer.onError(error!)
                    return
                }
                if let data = data {
                    observer.onNext(data)
                    observer.onCompleted()
                    return
                }else{
                    observer.onError(ApiError.NoDataInResponse())
                }
            })
            networkRequest.resume()
            let wrapUpTasks = Disposables.create {
                networkRequest.cancel()
            }
            return wrapUpTasks
        })
    }
}

struct ApiError {
    struct InvalidRequestError: Error {
        var description: String
        init(_ description: String) {
            self.description = description
        }
    }
    
    struct NoDataInResponse: Error {}
    
    struct InvalidResponse: Error {
        var description: String
        init(_ description: String){
            self.description = description
        }
    }
}
