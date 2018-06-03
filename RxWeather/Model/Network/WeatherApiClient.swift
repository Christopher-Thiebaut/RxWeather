//
//  WeatherApiClient.swift
//  RxWeather
//
//  Created by Christopher Thiebaut on 6/3/18.
//  Copyright © 2018 Christopher Thiebaut. All rights reserved.
//

import UIKit.UIImage
import RxSwift

protocol WeatherApiClient {
    func weather(for city: String) -> Observable<Weather>
    func image(with url: URL) -> Observable<UIImage>
}
