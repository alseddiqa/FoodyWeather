//
//  PhotoDetailViewController.swift
//  FoodyWeather
//
//  Created by Abdullah Alseddiq on 12/29/20.
//

import UIKit
import Kingfisher

class PhotoDetailViewController: UIViewController {

    @IBOutlet var imageView: UIImageView!
    
    var imageURL: URL!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        imageView.kf.setImage(with: imageURL)
    }

}
