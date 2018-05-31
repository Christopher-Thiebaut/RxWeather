//
//  OpenWeatherApi.swift
//  RxWeather
//
//  Created by Christopher Thiebaut on 5/30/18.
//  Copyright © 2018 Christopher Thiebaut. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

class OpenWeatherApi: RestApi {
    var session: URLSessionProtocol
    
    enum Units: String {
        case imperial
        case metric
    }
    
    var baseURL: URL = URL(string: "api.openweathermap.org/data")!
    private let queryName = "q"
    private let defaultQueryParameters = ["units":Units.imperial.rawValue,"appid":"868cbfc82ba196afbd20641467c11898"]
    
    required init(session: URLSessionProtocol) {
        self.session = session
    }
    
    func weather(for city: String) -> Observable<Weather?> {
        let requestParameters = [queryName:city].merging(defaultQueryParameters, uniquingKeysWith: {(oldValue, newValue) in return oldValue})
        let request = OpenWeatherRequest(parameters: requestParameters)
        let weather = makeDataRequest(request).map { (data) -> Weather? in
            guard let openWeatherResponse = (try? JSONDecoder().decode(OpenWeatherResponse.self, from: data)) else {
                return nil
            }
            return Weather(openWeatherResponse: openWeatherResponse)
        }
        return weather
    }
}

extension Weather {
    init(openWeatherResponse: OpenWeatherResponse) {
        self.init(currentTemp: openWeatherResponse.currentTemperature, lowTemp: openWeatherResponse.dailyLowTemp, highTemp: openWeatherResponse.dailyHighTemp, humidity: openWeatherResponse.currentHumidity, windSpeed: openWeatherResponse.currentWindSpeed, description: openWeatherResponse.weatherDescription, imageURL: openWeatherResponse.iconURL)
    }
}
