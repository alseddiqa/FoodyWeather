//
//  BusinessHourCell.swift
//  FoodyWeather
//
//  Created by Abdullah Alseddiq on 12/23/20.
//

import UIKit
import Lottie

class BusinessHourCell: UICollectionViewCell {
    
    var clockAnimation: AnimationView?
    
    @IBOutlet var viewBackground: UIView!
    @IBOutlet var dayLabel: UILabel!
    @IBOutlet var hoursOpenLabel: UILabel!
    
    override func layoutSubviews() {
        clockAnimation = .init(name: "clockAnimation")
        clockAnimation?.frame = viewBackground.frame
        clockAnimation?.loopMode = .loop
        viewBackground.addSubview(clockAnimation!)
        clockAnimation?.play()
    }
}
