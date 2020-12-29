//
//  BusinessTableCell.swift
//  FoodyWeather
//
//  Created by Abdullah Alseddiq on 12/16/20.
//

import UIKit

/// A cell class for the table of businesses
class BusinessTableCell: UITableViewCell {

    @IBOutlet var businessName: UILabel!
    @IBOutlet var category: UILabel!
    @IBOutlet var reviews: UILabel!
    @IBOutlet var starsImage: UIImageView!
    @IBOutlet var phoneNumber: UILabel!
    @IBOutlet var businessImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        //styling image
        businessImage.layer.cornerRadius = 15.0
        businessImage.layer.masksToBounds = true
    }

}
