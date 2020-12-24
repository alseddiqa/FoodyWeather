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
    @IBOutlet var addressButton: UIButton!
    
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
        if let address1 = business.location.address1, let address2 = business.location.address2 {
            let businessLocation = address1 + ", " + address2 + " " + business.location.city
            addressButton.setTitle(businessLocation, for: .normal)
        }
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
    
    @IBAction func openMap(_ sender: UIButton) {
        let latitude = Double(business.coordinates.latitude)
        let longitude = Double(business.coordinates.longitude)
        
        let appleURL = "http://maps.apple.com/?daddr=\(latitude),\(longitude)"
       
        let installedNavigationApps = [("Apple Maps", URL(string:appleURL)!)]
        
        let alert = UIAlertController(title: "Selection", message: "Select Navigation App", preferredStyle: .actionSheet)
        for app in installedNavigationApps {
            let button = UIAlertAction(title: app.0, style: .default, handler: { _ in
                UIApplication.shared.open(app.1, options: [:], completionHandler: nil)
            })
            alert.addAction(button)
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(cancel)
        present(alert, animated: true)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "BusinessMorePhotos":
            let destinationVC = segue.destination as! BusinessPhotosViewController
            destinationVC.business
                = business
        case "forcastDays":
            let destinationVC = segue.destination as! WeatherForcastViewController
            destinationVC.business
                = business
        case "openHours":
            let destinationVC = segue.destination as! BusinessHoursViewController
            destinationVC.business
                = business
        default:
            preconditionFailure("Unexpected segue identifier.")
        }
    }
    
}
