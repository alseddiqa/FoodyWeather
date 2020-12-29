//
//  ReviewDetailViewController.swift
//  FoodyWeather
//
//  Created by Abdullah Alseddiq on 12/28/20.
//

import UIKit

class ReviewDetailViewController: UIViewController {

    var businessReview: Review!
    
    //Declaring outlets for the VC
    @IBOutlet var reviewLabel: UILabel!
    @IBOutlet var reviewerProfilePicture: UIImageView!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var reviewRating: UILabel!
    @IBOutlet var reviewerLabel: UILabel!
    
    override func viewWillAppear(_ animated: Bool) {
        reviewLabel.text = businessReview.text
        reviewerLabel.text = businessReview.user.name
        dateLabel.text = "Date: " + businessReview.timeCreated
        reviewRating.text = "Review rating: " + String(businessReview.rating)
        let profileImge = URL(string: businessReview.user.imageURL!)
        reviewerProfilePicture.kf.setImage(with: profileImge)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        reviewerProfilePicture.layer.cornerRadius = 15
        reviewerProfilePicture.layer.masksToBounds = true

    }

}
