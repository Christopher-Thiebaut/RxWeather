//
//  OpenWeatherRequest.swift
//  RxWeather
//
//  Created by Christopher Thiebaut on 5/30/18.
//  Copyright © 2018 Christopher Thiebaut. All rights reserved.
//

import Foundation

struct OpenWeatherRequest: ApiRequest {
    var method: ApiRequestType
    var path: String
    var parameters: [String : String]
    
    init(parameters: [String : String]){
        self.method = .get
        self.path = ""
        self.parameters = parameters
    }
}
