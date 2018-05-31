//
//  OpenWeatherResponse.swift
//  RxWeather
//
//  Created by Christopher Thiebaut on 5/30/18.
//  Copyright © 2018 Christopher Thiebaut. All rights reserved.
//

import Foundation

struct OpenWeatherResponse: Decodable {
    
    enum TopLevelKeys: String, CodingKey {
        case weather
        case main
        case wind
        case calculationTime = "dt"
    }
    
    enum WeatherKeys: String, CodingKey {
        case description
        case icon
    }
    
    enum MainKeys: String, CodingKey {
        case temperature = "temp"
        case humidity
        case lowTemp = "temp_min"
        case highTemp = "temp_max"
    }
    
    enum WindKeys: String, CodingKey {
        case speed
    }
    
    var weatherDescription: String
    var iconURL: URL
    var currentTemperature: Float
    var currentHumidity: Float
    var dailyLowTemp: Float
    var dailyHighTemp: Float
    var currentWindSpeed: Float
    var calculationTime: TimeInterval
    
    private static let iconBaseURL = URL(string: "http://openweathermap.org/img/w")!
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: TopLevelKeys.self)
        
        var unkeyedWeatherContainer = try values.nestedUnkeyedContainer(forKey: .weather)
        let weatherContainer = try unkeyedWeatherContainer.nestedContainer(keyedBy: WeatherKeys.self)//try values.nestedContainer(keyedBy: WeatherKeys.self, forKey: .weather)
        self.weatherDescription = try weatherContainer.decode(String.self, forKey: .description)
        let imageName = try weatherContainer.decode(String.self, forKey: .icon)
        self.iconURL = OpenWeatherResponse.iconBaseURL.appendingPathExtension(imageName)
        
        let mainContainer = try values.nestedContainer(keyedBy: MainKeys.self, forKey: .main)
        self.currentTemperature = try mainContainer.decode(Float.self, forKey: .temperature)
        self.currentHumidity = try mainContainer.decode(Float.self, forKey: .humidity)
        self.dailyLowTemp = try mainContainer.decode(Float.self, forKey: .lowTemp)
        self.dailyHighTemp = try mainContainer.decode(Float.self, forKey: .highTemp)
        
        let windContainer = try values.nestedContainer(keyedBy: WindKeys.self, forKey: .wind)
        self.currentWindSpeed = try windContainer.decode(Float.self, forKey: .speed)
        
        self.calculationTime = try values.decode(TimeInterval.self, forKey: .calculationTime)
    }
    
}
