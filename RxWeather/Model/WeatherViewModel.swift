//
//  WeatherViewModel.swift
//  RxWeather
//
//  Created by Christopher Thiebaut on 6/2/18.
//  Copyright © 2018 Christopher Thiebaut. All rights reserved.
//

import UIKit
import RxSwift

class WeatherViewModel {
    
    let weatherClient: WeatherApiClient
    
    private var imageVariable: Variable<UIImage> = Variable(UIImage())
    private var descriptionVariable: Variable<String> = Variable("")
    private var locationNameVariable: Variable<String> = Variable("")
    private var temperatureVariable: Variable<Float> = Variable(0)
    private var lowTempVariable: Variable<Float> = Variable(0)
    private var highTempVariable: Variable<Float> = Variable(0)
    private var humidityVariable: Variable<Float> = Variable(0)
    private var windSpeedVariable: Variable<Float> = Variable(0)
    private var weatherLoading: Variable<Bool> = Variable(false)
    
    private var disposeBag = DisposeBag()
    private var lastSearchTerm = Variable("")
    
    lazy var image = imageVariable.asObservable()
    lazy var description = descriptionVariable.asObservable()
    lazy var locationName = locationNameVariable.asObservable()
    lazy var temperature = temperatureVariable.asObservable()
    lazy var lowTemp = lowTempVariable.asObservable()
    lazy var highTemp = highTempVariable.asObservable()
    lazy var humidity = humidityVariable.asObservable()
    lazy var windSpeed = windSpeedVariable.asObservable()
    lazy var isLoading = weatherLoading.asObservable()
    
    var locationInput: AnyObserver<String> {
        return  AnyObserver(eventHandler: {[weak self] (event) in
            switch event {
            case .next(let cityName):
                self?.updateWeather(forCityName: cityName)
                self?.lastSearchTerm.value = cityName
            default:
                break
            }
        })
    }
    
    init(weatherSource: WeatherApiClient) {
        self.weatherClient = weatherSource
    }
    
    private func updateWeather(forCityName cityName: String) {
        let weather = weatherClient.weather(for: cityName)
            .observeOn(MainScheduler.instance)
            .share()
        weatherLoading.value = true

        weather
            .subscribe(onNext: {[weak self] (weather) in
                self?.descriptionVariable.value = weather.description
                self?.locationNameVariable.value = weather.locationName
                self?.updateWeatherImage(imageURL: weather.imageURL)
                self?.temperatureVariable.value = weather.currentTemp
                self?.lowTempVariable.value = weather.lowTemp
                self?.highTempVariable.value = weather.highTemp
                self?.humidityVariable.value = weather.humidity
                self?.windSpeedVariable.value = weather.windSpeed
                }, onError: {[weak self] (error) in
                    self?.setVariableValuesForError()
                    self?.weatherLoading.value = false
                }, onCompleted: { [weak self] in
                    self?.weatherLoading.value = false
            }).disposed(by: disposeBag)
    }
    
    private func updateWeatherImage(imageURL: URL){
        weatherClient
            .image(with: imageURL)
            .subscribe(onNext: {[weak self] (image) in
                self?.imageVariable.value = image
                }, onError: {[weak self] (error) in
                    self?.imageVariable.value = #imageLiteral(resourceName: "no_image")
            })
            .disposed(by: disposeBag)
    }
    
    private func setVariableValuesForError() {
        locationNameVariable.value = lastSearchTerm.value
        descriptionVariable.value = "Error fetching weather"
        imageVariable.value = #imageLiteral(resourceName: "no_image")
    }
}
