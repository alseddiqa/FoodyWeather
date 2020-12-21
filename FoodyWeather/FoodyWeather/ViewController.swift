//
//  ViewController.swift
//  FoodyWeather
//
//  Created by Abdullah Alseddiq on 12/16/20.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var imageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let api = WeatherAPI(lat: 37.7670169511878, lon: -122.42184275)
        api.getWeatherForcastForBusiness()
        { (weatherFocaseResult) in
            guard let weatherFocaseResult = weatherFocaseResult else {
                return
            }
            print(weatherFocaseResult.forecast.forecastday.description)
        }

        
        //let api = YelpAPI(lat: 37.7670169511878, lon: -122.42184275)
        //api.getBusinessListForLocation()
        
//        let yelpApi = YelpAPI(lat: 0, lon: 0)
//        yelpApi.getBusinessDetails(id: "CYttYTEiQuhSfo3SEh79fA") { (details) in
//            guard let details = details else {
//                return
//            }
//            print(details)
//        }
    }


}

