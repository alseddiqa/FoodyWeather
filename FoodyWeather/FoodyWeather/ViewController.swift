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
        api.getWeatherForLocation() { (weatherResult) in
            guard let weatherResult = weatherResult else {
                return
            }
            let weatherIconUrl = URL(string: "http:" + weatherResult.condition.icon)
            self.imageView.load(url: weatherIconUrl!)
        }

        
        //let api = YelpAPI(lat: 37.7670169511878, lon: -122.42184275)
        //api.getBusinessListForLocation()
    }


}

