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
    
    let weatherClient: OpenWeatherApi
    
    private var imageVariable: Variable<UIImage> = Variable(UIImage())
    private var descriptionVariable: Variable<String> = Variable("")
    private var disposeBag = DisposeBag()
    private let session: URLSessionProtocol
    
    lazy var image = imageVariable.asObservable()
    lazy var description = descriptionVariable.asObservable()
    
    var location: AnyObserver<String> {
        return  AnyObserver(eventHandler: {[weak self] (event) in
            switch event {
            case .next(let cityName):
                self?.updateWeather(forCityName: cityName)
            default:
                break
            }
        })
    }
    
    init(session: URLSessionProtocol = URLSession.shared) {
        self.session = session
        self.weatherClient = OpenWeatherApi(session: session)
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
    }
    
    private func updateWeatherImage(imageURL: URL){
        weatherClient
            .icon(with: imageURL)
            .subscribe(onNext: {[weak self] (image) in
                self?.imageVariable.value = image
                }, onError: { (error) in
                    //TODO: Handle Error
            })
            .disposed(by: disposeBag)
    }
}
