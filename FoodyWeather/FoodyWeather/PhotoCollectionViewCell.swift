//
//  PhotoCollectionViewCell.swift
//  FoodyWeather
//
//  Created by Abdullah Alseddiq on 12/18/20.
//

import UIKit

class PhotoCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet var imageView: UIImageView!
    
}

/// an extension to style cell for the collection view
extension UICollectionViewCell {
    func shadowDecorate() {
        let radius: CGFloat = 10
        contentView.layer.cornerRadius = radius
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = UIColor.clear.cgColor
        contentView.layer.masksToBounds = true
    
    }
    
}
