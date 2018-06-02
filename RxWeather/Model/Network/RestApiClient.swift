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

protocol RestApiClient: class {

    var session:  URLSessionProtocol { get }
    init(session: URLSessionProtocol)
    func makeDataRequest(_ request: ApiRequest, with baseURL: URL) -> Observable<Data>
}

extension RestApiClient {
    
    func makeDataRequest(_ request: ApiRequest, with baseURL: URL) -> Observable<Data> {
        return Observable.create({[unowned self] (observer) -> Disposable in
            guard  let urlRequest = request.urlRequest(with: baseURL) else {
                observer.onError(ApiError.InvalidRequestError("The provided ApiRequest cannot be translated into a valid query."))
                return Disposables.create()
            }
            let networkRequest = self.session.dataTask(with: urlRequest, completionHandler: { (data, response, error) in
                guard error == nil else {
                    observer.onError(error!)
                    return
                }
                if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode < 200 || httpResponse.statusCode > 299 {
                    observer.onError(ApiError.InvalidResponse("Received invalid http response: \(httpResponse.statusCode)"))
                } else if let data = data {
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
