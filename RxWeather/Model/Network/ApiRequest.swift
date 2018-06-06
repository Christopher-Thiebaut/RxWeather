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
        guard var urlComponents = getURLComponents(forBaseURL: baseURL, andPath: path) else {
            NSLog("\(String(describing: self)) could not form urlComponents for request url with the provided baseURL and path.")
            return nil
        }
        
        urlComponents.queryItems = getQueryItems(forParameters: parameters)

        guard let requestURL = urlComponents.url else {
            NSLog("\(String(describing: self)) could not create a request URL with the supplied parameters.")
            return nil
        }
        var request = URLRequest(url: requestURL)
        request.httpMethod = method.rawValue
        return request
    }
    
    private func getURLComponents(forBaseURL baseURL: URL, andPath path: String) -> URLComponents? {
        if path.isEmpty {
            return URLComponents(url: baseURL, resolvingAgainstBaseURL: false)
        }else{
            return URLComponents(url: baseURL.appendingPathComponent(path), resolvingAgainstBaseURL: false)
        }
    }
    
    private func getQueryItems(forParameters parameters: [String:String]) -> [URLQueryItem]? {
        if parameters.count > 0 {
            return parameters.map({URLQueryItem(name: $0.key, value: $0.value)})
        }else{
            return nil
        }
    }
}

enum ApiRequestType: String {
    case get
    case post
    case put
}
