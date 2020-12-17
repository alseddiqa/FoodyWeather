//
//  ViewController.swift
//  FoodyWeather
//
//  Created by Abdullah Alseddiq on 12/16/20.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let api = WeatherAPI(lat: 37.7670169511878, lon: -122.42184275)
        api.getWeatherForLocation()

        
        //let api = YelpAPI(lat: 37.7670169511878, lon: -122.42184275)
        //api.getBusinessListForLocation()
    }


}

