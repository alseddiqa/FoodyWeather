//
//  BusinessTableCell.swift
//  FoodyWeather
//
//  Created by Abdullah Alseddiq on 12/16/20.
//

import UIKit

class BusinessTableCell: UITableViewCell {

    @IBOutlet var businessName: UILabel!
    @IBOutlet var category: UILabel!
    @IBOutlet var reviews: UILabel!
    @IBOutlet var starsImage: UIImageView!
    @IBOutlet var phoneNumber: UILabel!
    @IBOutlet var businessImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
//        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0))
        businessImage.layer.cornerRadius = 15.0
        businessImage.layer.masksToBounds = true
    }

}
