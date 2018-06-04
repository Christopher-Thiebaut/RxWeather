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
    
    lazy var image = imageVariable.asObservable()
    lazy var description = descriptionVariable.asObservable()
    lazy var locationName = locationNameVariable.asObservable()
    
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
        weather
            .map({return $0.description})
            .subscribe(onNext: {[self] (weatherDescription) in
                self.descriptionVariable.value = weatherDescription
            }, onError: { (error) in
                //TODO: handle error
            })
            .disposed(by: disposeBag)
        weather
            .map({$0.imageURL})
            .subscribe(onNext: {[weak self] (url) in
                self?.updateWeatherImage(imageURL: url)
                }, onError: { (error) in
                    //TODO: Handle Error
            })
            .disposed(by: disposeBag)
        weather.map({$0.locationName})
            .subscribe(onNext: {[weak self] (locationName) in
                self?.locationNameVariable.value = locationName
                }, onError: { (error) in
                    //TODO: Handle Error
            }).disposed(by: disposeBag)
    }
    
    private func updateWeatherImage(imageURL: URL){
        weatherClient
            .image(with: imageURL)
            .subscribe(onNext: {[weak self] (image) in
                self?.imageVariable.value = image
                }, onError: { (error) in
                    //TODO: Handle Error
            })
            .disposed(by: disposeBag)
    }
}
