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
        
        let api = YelpAPI(lat: 37.335480, lon: -121.893028)
        api.getBusinessListForLocation()
    }


}

