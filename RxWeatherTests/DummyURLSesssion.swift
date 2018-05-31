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
    let sampleData = """
                            {"coord":
                            {"lon":145.77,"lat":-16.92},
                            "weather":[{"id":803,"main":"Clouds","description":"broken clouds","icon":"04n"}],
                            "base":"cmc stations",
                            "main":{"temp":293.25,"pressure":1019,"humidity":83,"temp_min":289.82,"temp_max":295.37},
                            "wind":{"speed":5.1,"deg":150},
                            "clouds":{"all":75},
                            "rain":{"3h":3},
                            "dt":1435658272,
                            "sys":{"type":1,"id":8166,"message":0.0166,"country":"AU","sunrise":1435610796,"sunset":1435650870},
                            "id":2172797,
                            "name":"Cairns",
                            "cod":200}
                            """.data(using: .ascii)
    
    enum DummySessionErrors: Error {
        case intentionalError(String)
    }
    
    /**
        This data task does nothing and will pass sample data to the completion handler that is from the OpenWeatherApi when this test class was written if the provided URL contains the word 'success' and will pass an error to the completion handler.  It does nothing with the URL response as the class it was designed to test doesn't do anything with that either.
     */
    func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTaskProtocol {
        guard let urlString = request.url?.absoluteString, urlString.contains("success") else {
            completionHandler(nil, nil, DummySessionErrors.intentionalError("This is a simulated error because the target URL did not contain the string 'success'"))
            return DummyDataTask()
        }
        completionHandler(sampleData, nil, nil)
        return DummyDataTask()
    }
}
