//
//  SearchResultCell.swift
//  FoodyWeather
//
//  Created by Abdullah Alseddiq on 12/26/20.
//

import UIKit

class SearchResultCell: UITableViewCell {

    @IBOutlet var locationName: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
