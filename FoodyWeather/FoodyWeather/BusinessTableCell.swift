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

}
