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
    private var disposeBag = DisposeBag()
    private var weatherLoading: Variable<Bool> = Variable(false)
    
    lazy var image = imageVariable.asObservable()
    lazy var description = descriptionVariable.asObservable()
    lazy var locationName = locationNameVariable.asObservable()
    lazy var isLoading = weatherLoading.asObservable()
    
    var locationInput: AnyObserver<String> {
        return  AnyObserver(eventHandler: {[weak self] (event) in
            switch event {
            case .next(let cityName):
                self?.updateWeather(forCityName: cityName)
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
        locationNameVariable.value = "Error"
        descriptionVariable.value = "Error fetching weather"
        imageVariable.value = #imageLiteral(resourceName: "no_image")
    }
}
