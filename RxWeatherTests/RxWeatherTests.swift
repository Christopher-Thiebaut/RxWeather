//
//  RxWeatherTests.swift
//  RxWeatherTests
//
//  Created by Christopher Thiebaut on 5/29/18.
//  Copyright © 2018 Christopher Thiebaut. All rights reserved.
//

import XCTest
import RxCocoa
import RxSwift
@testable import RxWeather

class RxWeatherTests: XCTestCase {
    
    let disposeBag = DisposeBag()
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testOpenWeatherApiFetch() {
        let imageFound = expectation(description: "Image found")
        let openWeatherApi = OpenWeatherApiClient(session: DummyURLSession())
        let weatherSubject: PublishSubject<Weather> = PublishSubject()
        weatherSubject.subscribe(onNext: { (weather) in
            openWeatherApi.image(with: weather.imageURL)
                .subscribe(onNext: { (image) in
                    imageFound.fulfill()
                }).disposed(by: self.disposeBag)
        }).disposed(by: disposeBag)
        openWeatherApi.weather(for: "success").subscribe(onNext: { (weather) in
            weatherSubject.onNext(weather)
        }).disposed(by: disposeBag)
        wait(for: [imageFound], timeout: 5)
    }
    
    func testOpenWeatherComplete() {
        let observableCompleted = expectation(description: "Observable completes.")
        let openWeatherApi = OpenWeatherApiClient(session: DummyURLSession())
        openWeatherApi.weather(for: "success").subscribe(onCompleted: {
            observableCompleted.fulfill()
        }).disposed(by: disposeBag)
        wait(for: [observableCompleted], timeout: 5)
    }
    
    func testDataFetchCompletes() {
        let dataFetchCompletes = expectation(description: "Fetch Completes")
        let openWeatherApi = OpenWeatherApiClient(session: DummyURLSession())
        let testApiRequest = OpenWeatherRequest(parameters: ["q":"success"])
        openWeatherApi.makeDataRequest(testApiRequest, with: openWeatherApi.baseURL).subscribe(onCompleted: {
            dataFetchCompletes.fulfill()
        }).disposed(by: disposeBag)
        wait(for: [dataFetchCompletes], timeout: 5)
    }
    
    func testOpenWeatherResponseDecoding() {
        let sampleResponse = """
                            {"coord":
                            {"lon":145.77,"lat":-16.92},
                            "weather":[{"id":803,"main":"Clouds","description":"broken clouds","icon":"04n"}],
                            "base":"cmc stations",
                            "main":{"temp":293.25,"pressure":1019,"humidity":83,"temp_min":289.82,"temp_max":295.37},
                            "wind":{"speed":5.1,"deg":150},
                            "clouds":{"all":75},
                            "rain":{"3h":3},
                            "dt":1435658272,
                            "sys":{"type":1,"id":8166,"message":0.0166,"country":"AU","sunrise":1435610796,"sunset":1435650870},
                            "id":2172797,
                            "name":"Cairns",
                            "cod":200}
                            """.data(using: .ascii)
        let weatherResponse = (try? JSONDecoder().decode(OpenWeatherResponse.self,from: sampleResponse!))
        XCTAssert(weatherResponse != nil)
    }
    
    func testViewModelDescriptionAndImageFetched() {
        let descriptionUpdatedExpection = expectation(description: "Description Updated")
        descriptionUpdatedExpection.expectedFulfillmentCount = 2
        let imageFetchedExpectation = expectation(description: "Image fetched")
        imageFetchedExpectation.expectedFulfillmentCount = 2
        let weatherClient = OpenWeatherApiClient(session: DummyURLSession())
        let weatherViewModel = WeatherViewModel(weatherSource: weatherClient)
        weatherViewModel.description.subscribe(onNext: { (description) in
            NSLog("\(description)")
            descriptionUpdatedExpection.fulfill()
        }).disposed(by: disposeBag)
        weatherViewModel.image.subscribe(onNext: { (image) in
            imageFetchedExpectation.fulfill()
        }).disposed(by: disposeBag)
        let dummySearchInfo = Observable.just("success")
        dummySearchInfo.bind(to: weatherViewModel.locationInput).disposed(by: disposeBag)
        wait(for: [descriptionUpdatedExpection, imageFetchedExpectation], timeout: 5)
    }
    
}
