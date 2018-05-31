//
//  URLSessionProtocol.swift
//  RxWeather
//
//  Created by Christopher Thiebaut on 5/30/18.
//  Copyright © 2018 Christopher Thiebaut. All rights reserved.
//

import Foundation

public protocol URLSessionProtocol {
    typealias DataTaskResult = (Data?, URLResponse?, Error?) -> Void
    
    func dataTask(with: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask
}

extension URLSession: URLSessionProtocol {}

