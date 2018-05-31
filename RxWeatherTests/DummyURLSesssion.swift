//
//  DummyURLSesssion.swift
//  RxWeatherTests
//
//  Created by Christopher Thiebaut on 5/30/18.
//  Copyright © 2018 Christopher Thiebaut. All rights reserved.
//

import Foundation
import RxWeather

class DummyURLSession: URLSessionProtocol {
    func dataTask(with: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        
        
        return URLSessionDataTask()
    }
}
