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
    @IBOutlet var closingHourLabel: UILabel!
    
    override func layoutSubviews() {
        
        let radius: CGFloat = 10
        contentView.layer.cornerRadius = radius
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = UIColor.clear.cgColor
        contentView.layer.masksToBounds = false
        
        clockAnimation = .init(name: "clockAnimation")
        clockAnimation?.frame = viewBackground.frame
        viewBackground.addSubview(clockAnimation!)

        clockAnimation?.centerXAnchor.constraint(equalTo: viewBackground.centerXAnchor).isActive = true
        clockAnimation?.centerYAnchor.constraint(equalTo: viewBackground.centerYAnchor).isActive = true
        clockAnimation?.translatesAutoresizingMaskIntoConstraints = false

        clockAnimation?.loopMode = .loop
        clockAnimation?.animationSpeed = 0.5
        clockAnimation?.play()
        
        
    }
}
