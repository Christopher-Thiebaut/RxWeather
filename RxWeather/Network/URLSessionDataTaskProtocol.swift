//
//  URLSessionDataTaskProtocol.swift
//  RxWeather
//
//  Created by Christopher Thiebaut on 5/31/18.
//  Copyright © 2018 Christopher Thiebaut. All rights reserved.
//

import Foundation

public protocol URLSessionDataTaskProtocol {
    func resume() -> Void
    func cancel() -> Void
}

extension URLSessionDataTask: URLSessionDataTaskProtocol {}
