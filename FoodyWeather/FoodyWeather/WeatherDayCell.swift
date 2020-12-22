//
//  WeatherDayCell.swift
//  FoodyWeather
//
//  Created by Abdullah Alseddiq on 12/21/20.
//

import UIKit

class WeatherDayCell: UICollectionViewCell {
    
    @IBOutlet var weatherImage: UIImageView!
    @IBOutlet var weatherTempLabel: UILabel!
    @IBOutlet var dayLabel: UILabel!
    
    override func layoutSubviews() {
        weatherImage.layer.cornerRadius = 7.5
        weatherImage.layer.masksToBounds = true
    }
}