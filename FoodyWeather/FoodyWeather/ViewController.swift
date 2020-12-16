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
        
        let api = YelpAPI(lat: 51.509865, lon: 0.118092)
        api.getBusinessListForLocation()
    }


}

