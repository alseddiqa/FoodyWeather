//
//  DayWeatherDetailViewController.swift
//  FoodyWeather
//
//  Created by Abdullah Alseddiq on 12/22/20.
//

import UIKit

class DayWeatherDetailViewController: UIViewController {

    @IBOutlet var datePicker: UIDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        datePicker.backgroundColor = #colorLiteral(red: 0.1058823529, green: 0.1490196078, blue: 0.1725490196, alpha: 1)

    }

}
