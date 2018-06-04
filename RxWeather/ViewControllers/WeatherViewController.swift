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
            .map({$0?.lowercased() ?? ""})
            .debounce(0.3, scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .bind(to: weatherViewModel.location)
            .disposed(by: disposeBag)
    }
    
    func bindViewModelToViews() {
        weatherViewModel.description.bind(to: descriptionLabel.rx.text).disposed(by: disposeBag)
        weatherViewModel.image.bind(to: iconImageView.rx.image).disposed(by: disposeBag)
    }

}

