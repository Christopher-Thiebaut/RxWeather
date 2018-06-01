//
//  ApiRequest.swift
//  RxWeather
//
//  Created by Christopher Thiebaut on 5/30/18.
//  Copyright © 2018 Christopher Thiebaut. All rights reserved.
//

import Foundation

protocol ApiRequest {
    var method: ApiRequestType { get }
    var path: String { get }
    var parameters: [String:String] { get }
}

extension ApiRequest {
    func urlRequest(with baseURL: URL) -> URLRequest? {
        guard var urlComponents = URLComponents(url: baseURL.appendingPathComponent(path), resolvingAgainstBaseURL: false) else {
            NSLog("\(String(describing: self)) could not form urlComponents for request url with the provided baseURL and path.")
            return nil
        }
        urlComponents.queryItems = parameters.map({URLQueryItem(name: $0.key, value: $0.value)})
        guard let requestURL = urlComponents.url else {
            NSLog("\(String(describing: self)) could not create a request URL with the supplied parameters.")
            return nil
        }
        var request = URLRequest(url: requestURL)
        request.httpMethod = method.rawValue
        //This informs the server that our client will understand a json response to our request
//        request.addValue("application/json", forHTTPHeaderField: "Accept")
        return request
    }
}

enum ApiRequestType: String {
    case get
    case post
    case put
}
