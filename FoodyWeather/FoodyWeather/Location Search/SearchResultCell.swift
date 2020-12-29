//
//  SearchResultCell.swift
//  FoodyWeather
//
//  Created by Abdullah Alseddiq on 12/26/20.
//

import UIKit

/// A table cell class to display auto complete location results from weather api
class SearchResultCell: UITableViewCell {

    @IBOutlet var locationName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
