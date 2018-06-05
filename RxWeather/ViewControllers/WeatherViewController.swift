//
//  ViewController.swift
//  RxWeather
//
//  Created by Christopher Thiebaut on 5/29/18.
//  Copyright © 2018 Christopher Thiebaut. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class WeatherViewController: UIViewController {
    
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var highTempLabel: UILabel!
    @IBOutlet weak var lowTempLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var windSpeedLabel: UILabel!
    @IBOutlet weak var searchBar: UISearchBar!
    
    private var weatherViewModel: WeatherViewModel = WeatherViewModel(weatherSource: OpenWeatherApiClient())
    private let disposeBag = DisposeBag()
    var searchTermStream: Observable<String> = Observable.just("Detroit")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        bindSearchTextToViewModel()
        bindViewModelToViews()
    }
    
    func bindSearchTextToViewModel(){
        searchBar.rx.text.asObservable()
            .map({$0?.uppercased() ?? ""})
            .filter({!$0.isEmpty})
            .debounce(0.5, scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .bind(to: weatherViewModel.locationInput)
            .disposed(by: disposeBag)
    }
    
    func bindViewModelToViews() {
        weatherViewModel.description.map({$0.uppercased()}).bind(to: descriptionLabel.rx.text).disposed(by: disposeBag)
        weatherViewModel.image.bind(to: iconImageView.rx.image).disposed(by: disposeBag)
        weatherViewModel.locationName.bind(to: cityNameLabel.rx.text).disposed(by: disposeBag)
        bindImperialTemperature(weatherViewModel.temperature, toLabel: temperatureLabel)
        bindImperialTemperature(weatherViewModel.lowTemp, toLabel: lowTempLabel)
        bindImperialTemperature(weatherViewModel.highTemp, toLabel: highTempLabel)
        weatherViewModel.humidity.map({"\($0)%"}).bind(to: humidityLabel.rx.text).disposed(by: disposeBag)
        weatherViewModel.windSpeed.map({"\($0) mph"}).bind(to: windSpeedLabel.rx.text).disposed(by: disposeBag)
    }
    
    private func bindImperialTemperature(_ temperature: Observable<Float>, toLabel label: UILabel) {
        temperature.map({"\($0) °F"}).bind(to: label.rx.text).disposed(by: disposeBag)
    }

}

