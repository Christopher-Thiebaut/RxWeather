//
//  DummyDataTask.swift
//  RxWeatherTests
//
//  Created by Christopher Thiebaut on 5/31/18.
//  Copyright © 2018 Christopher Thiebaut. All rights reserved.
//

import Foundation
import RxWeather

class DummyDataTask: URLSessionDataTaskProtocol {
    func resume() {
        NSLog("Resume called on dummy data task.")
    }
    
    func cancel() {
        NSLog("Cancel called on dummy data task.")
    }
}
