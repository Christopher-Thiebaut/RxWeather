//
//  Weather.swift
//  RxWeather
//
//  Created by Christopher Thiebaut on 5/30/18.
//  Copyright © 2018 Christopher Thiebaut. All rights reserved.
//

import UIKit

struct Weather {
    let currentTemp: Float
    let lowTemp: Float
    let highTemp: Float
    let humidity: Float
    let windSpeed: Float
    let description: String
    let imageURL: URL
}
