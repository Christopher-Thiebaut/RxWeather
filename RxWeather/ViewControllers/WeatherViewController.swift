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
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        subcscribeToWeather(for: "Detroit")
    }
    
    func subcscribeToWeather(for city: String){
        let openWeatherApi = OpenWeatherApi()
        openWeatherApi.weather(for: city)
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: {[weak self] (weather) in
                self?.descriptionLabel.text = weather.description
                guard let disposeBag = self?.disposeBag else { return }
                openWeatherApi.icon(with: weather.imageURL)
                    .observeOn(MainScheduler.instance)
                    .subscribe(onNext: { (image) in
                    self?.iconImageView.image = image
                }).disposed(by: disposeBag)
                }, onError: { (error) in
                    //TODO: More robust error handling here
                    print("Error fetching weather: \(error.localizedDescription)")
            }).disposed(by: disposeBag)
    }

}

