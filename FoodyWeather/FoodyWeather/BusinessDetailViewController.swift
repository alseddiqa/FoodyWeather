//
//  BusinessDetailViewController.swift
//  FoodyWeather
//
//  Created by Abdullah Alseddiq on 12/18/20.
//

import UIKit

class BusinessDetailViewController: UIViewController {

    @IBOutlet var businessImage: UIImageView!
    @IBOutlet var nameOfBusiness: UILabel!
    @IBOutlet var categoryLabel: UILabel!
    @IBOutlet var starsImage: UIImageView!
    @IBOutlet var reviewNum: UILabel!
    @IBOutlet var phoneNumLabel: UILabel!
    
    var business: Business!
    var businessDetail: BusinessDetail!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        nameOfBusiness.text = business.name
        categoryLabel.text = business.categories[0].title
        businessImage.load(url: URL(string: business.imageURL)!)
        reviewNum.text = String(business.reviewCount)
        let reviewDouble = business.rating
        starsImage.image = Stars.dict[reviewDouble]!
        phoneNumLabel.text = business.displayPhone
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getBusinessDetails(businessId: business.id)
        // Do any additional setup after loading the view.
    }
    
    func getBusinessDetails(businessId: String) {
        let yelpApi = YelpAPI(lat: 0, lon: 0)
        yelpApi.getBusinessDetails(id: businessId) { (details) in
            guard let details = details else {
                return
            }
            self.businessDetail = details
            //do more update to UI
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "BusinessMorePhotos":
            let destinationVC = segue.destination as! BusinessPhotosViewController
            destinationVC.business
            = business
        default:
            preconditionFailure("Unexpected segue identifier.")
        }
    }

}
