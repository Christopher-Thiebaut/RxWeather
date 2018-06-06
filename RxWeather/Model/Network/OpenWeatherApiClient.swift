//
//  OpenWeatherApi.swift
//  RxWeather
//
//  Created by Christopher Thiebaut on 5/30/18.
//  Copyright © 2018 Christopher Thiebaut. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class OpenWeatherApiClient: RestApiClient, WeatherApiClient {
    
    var session: URLSessionProtocol
    let baseURL: URL = URL(string: "https://api.openweathermap.org/data/2.5/weather")!
    
    enum Units: String {
        case imperial
        case metric
    }
    
    private let queryName = "q"
    private let defaultQueryParameters = ["units":Units.imperial.rawValue,"appid":"Your own Api Key here"]
    
    required init(session: URLSessionProtocol = URLSession.shared) {
        self.session = session
    }
    
    func weather(for city: String) -> Observable<Weather> {
        let requestParameters = [queryName:city].merging(defaultQueryParameters, uniquingKeysWith: {(oldValue, newValue) in return oldValue})
        let request = OpenWeatherRequest(parameters: requestParameters)
        let weather = makeDataRequest(request, with: baseURL).map { (data) -> Weather? in
            guard let openWeatherResponse = (try? JSONDecoder().decode(OpenWeatherResponse.self, from: data)) else {
                return nil
            }
            return Weather(openWeatherResponse: openWeatherResponse)
            }.filter {$0 != nil}.map({return $0!})
        return weather
    }
    
    func image(with url: URL) -> Observable<UIImage> {
        let imageRequest = OpenWeatherRequest(parameters: [:])
        let imageObservable = makeDataRequest(imageRequest, with: url).map { (data) -> UIImage? in
            let image = UIImage(data: data)
            return image
            }.filter({$0 != nil}).map({$0!})
        return imageObservable
    }
}

extension Weather {
    init(openWeatherResponse: OpenWeatherResponse) {
        self.init(currentTemp: openWeatherResponse.currentTemperature, lowTemp: openWeatherResponse.dailyLowTemp, highTemp: openWeatherResponse.dailyHighTemp, humidity: openWeatherResponse.currentHumidity, windSpeed: openWeatherResponse.currentWindSpeed, description: openWeatherResponse.weatherDescription, imageURL: openWeatherResponse.iconURL, locationName: openWeatherResponse.name)
    }
}
