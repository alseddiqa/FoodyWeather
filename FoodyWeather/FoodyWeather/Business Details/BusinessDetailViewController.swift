//
//  BusinessDetailViewController.swift
//  FoodyWeather
//
//  Created by Abdullah Alseddiq on 12/18/20.
//

import UIKit

class BusinessDetailViewController: UIViewController {
    
    //Declaring outlets of the view
    @IBOutlet var businessImage: UIImageView!
    @IBOutlet var nameOfBusiness: UILabel!
    @IBOutlet var categoryLabel: UILabel!
    @IBOutlet var starsImage: UIImageView!
    @IBOutlet var reviewNum: UILabel!
    @IBOutlet var phoneNumLabel: UILabel!
    @IBOutlet var addressButton: UIButton!
    @IBOutlet var photosLabel: UILabel!
    @IBOutlet var weatherLabel: UILabel!
    @IBOutlet var hoursLabel: UILabel!
    @IBOutlet var reviewsSectionLabel: UILabel!
    
    var business: Business!
    var businessDetail: BusinessDetail!
    var savedBusiness: SavedBusiness!
    var businessStorage: BusinessStorage!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        displayBusinessInformation()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if business != nil {
            getBusinessDetails(businessId: business.id)
        }
    }
    
    /// A function to display business details information depending if it's stored or fetched
    func displayBusinessInformation() {
        if business != nil {
            nameOfBusiness.text = business.name
            categoryLabel.text = business.categories[0].title
            businessImage.kf.setImage(with: URL(string: business.imageURL))
            reviewNum.text = String(business.reviewCount)
            let reviewDouble = business.rating
            starsImage.image = Stars.dict[reviewDouble]!
            phoneNumLabel.text = business.displayPhone
            if let address1 = business.location.address1, let address2 = business.location.address2 {
                let businessLocation = address1 + ", " + address2 + business.location.city
                addressButton.setTitle(businessLocation, for: .normal)
            }
        }
        else {
            nameOfBusiness.text = savedBusiness.name
            categoryLabel.text = savedBusiness.businessCategory
            businessImage.kf.setImage(with: URL(string: savedBusiness.imageURL))
            reviewNum.text = String(savedBusiness.reviewCount)
            let reviewDouble = savedBusiness.businessRating
            starsImage.image = Stars.dict[reviewDouble]!
            phoneNumLabel.text = savedBusiness.displayPhone
            if let address1 = savedBusiness.location.address1, let address2 = savedBusiness.location.address2 {
                let businessLocation = address1 + ", " + address2 + " " + savedBusiness.location.city
                addressButton.setTitle(businessLocation, for: .normal)
            }
            setInformationLabels()
        }
        
    }
    
    /// set labels if no more information is available
    func setInformationLabels(){
        if savedBusiness.businessHours.count == 0{
            hoursLabel.text = ""
        }
        if savedBusiness.businessPhotos.count == 0 {
            photosLabel.text = "Other information not available. (no internet) "
        }
        if savedBusiness.forcastDays.count == 0 {
            weatherLabel.text = ""
        }
        if savedBusiness.businessReviews.count == 0 {
            reviewsSectionLabel.text = ""
        }
    }
    
    /// A helper function to get the business details of the business
    /// - Parameter businessId: business id
    func getBusinessDetails(businessId: String) {
        YelpAPI.getBusinessDetails(id: businessId) { (details) in
            guard let details = details else {
                return
            }
            self.businessDetail = details
        }
    }
    
    /// A helper function to open apple maps when the user taps on to allow the user to start the navigation
    /// - Parameter sender: the location button
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
    
    //Preparing for the container views segues
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        switch segue.identifier {
        case "BusinessMorePhotos":
            let destinationVC = segue.destination as! BusinessPhotosViewController
            destinationVC.business
                = business
            destinationVC.businessStorage = businessStorage

            if business == nil {
                destinationVC.businessPhotos = savedBusiness.businessPhotos
            }
        case "forcastDays":
            let destinationVC = segue.destination as! WeatherForcastViewController
            destinationVC.business
                = business
            destinationVC.businessStorage = businessStorage
            if business == nil {
                destinationVC.forcastDays = savedBusiness.forcastDays
            }
        case "openHours":
            let destinationVC = segue.destination as! BusinessHoursViewController
            destinationVC.business
                = business
            destinationVC.businessStorage = businessStorage
            if business == nil {
                destinationVC.businessHours = savedBusiness.businessHours
            }
        case "businessReview":
            let destinationVC = segue.destination as! ReviewsViewController
            destinationVC.business
                = business
            destinationVC.businessStorage = businessStorage
            if business == nil {
                destinationVC.reviews = savedBusiness.businessReviews
            }

        default:
            preconditionFailure("Unexpected segue identifier.")
            
        }
    }
    
}

// An animation to make a label
extension UILabel {
    func blink() {
        self.alpha = 0.0;
        UIView.animate(withDuration: 0.8, //Time duration you want,
                            delay: 0.0,
                            options: [.curveEaseInOut, .autoreverse, .repeat],
                       animations: { [weak self] in self?.alpha = 1.0 },
                       completion: { [weak self] _ in self?.alpha = 0.0 })
    }
}
