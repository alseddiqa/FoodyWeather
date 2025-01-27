//
//  WeatherHourCell.swift
//  FoodyWeather
//
//  Created by Abdullah Alseddiq on 12/22/20.
//

import UIKit

/// A cell class to configure weather table cell
class WeatherHourCell: UITableViewCell {
    
    @IBOutlet var conditionIcon: UIImageView!
    @IBOutlet var timeLabel: UILabel!
    @IBOutlet var tempLabel: UILabel!
    @IBOutlet var rainChanceLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
