//
//  BusinessesViewController.swift
//  FoodyWeather
//
//  Created by Abdullah Alseddiq on 12/16/20.
//

import UIKit
import CoreLocation

class BusinessesViewController: UIViewController {

    var businessesStore: BusinessStore!
    var userLocationManager: UserLocationService!
    var currentLocationStatus: Bool = true

    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var searchTextField: UITextField!
    @IBOutlet var weatherImage: UIImageView!
    @IBOutlet var tempratureLabel: UILabel!
    @IBOutlet var weatherConditionLabel: UILabel!
    @IBOutlet var locationButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        userLocationManager = UserLocationService()
        userLocationManager.delegate = self
        
        
        businessesStore = BusinessStore()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(observeStoreLoadNotification(note:)),
                                               name: .businessesLoadedYelp,
                                               object: nil)
        
        setUpSubView()
    }
    
    @objc func observeStoreLoadNotification(note: Notification) {
        tableView.reloadData()
        if businessesStore.businesses.count != 0 {
            let city = businessesStore.businesses[0].location.city
            let state = businessesStore.businesses[0].location.state
            if state.count != 0 && city.count != 0 {
                let location = city + "," + state
                locationButton.setTitle(location, for: .application)
            }
            
        }
    }
    
    func getWeatherInformation(latitude: Double, longitude: Double) {
        let api = WeatherAPI(lat: latitude, lon: longitude)
        api.getWeatherForLocation() { (weatherResult) in
            guard let weatherResult = weatherResult else {
                return
            }
            if let weatherIconUrl = URL(string: "http:" + weatherResult.current.condition.icon) {
                self.weatherImage.load(url: weatherIconUrl)
            }
            //self.cityLabel.text = weatherResult.location.name
            self.locationButton.setTitle(weatherResult.location.name, for: .normal)
            self.tempratureLabel.text = String(weatherResult.current.tempC) + "°C"
            self.weatherConditionLabel.text = weatherResult.current.condition.text
        }
    }

    
    func setUpSubView() {
        searchTextField.layer.cornerRadius = 15.0
        searchTextField.layer.masksToBounds = true
    }
    
    @IBAction func searchRestaurant(_ sender: UIButton) {
        let searchKeyWord = searchTextField.text
        businessesStore.searchForBusiness(restaurant: searchKeyWord!, lat: userLocationManager.latitude, lon: userLocationManager.longitude)
    }
    
    func loadBusinessesForPinnedLocation(cordinates: CLLocationCoordinate2D) {
            businessesStore.loadBusinessesForLocation(lat: cordinates.latitude, lon: cordinates.longitude)
            self.getWeatherInformation(latitude: cordinates.latitude, longitude: cordinates.longitude)
        
    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "BusinessDetail":
            if let selectedIndexPath =
                tableView.indexPathForSelectedRow?.row {
                let business = businessesStore.businesses[selectedIndexPath]
                let destinationVC = segue.destination as! BusinessDetailViewController
                destinationVC.business = business
            }
        case "MapViewSegue":
            let destinationVC = segue.destination as! MapViewController
            destinationVC.mapDelegate = self
        
        default:
            preconditionFailure("Unexpected segue identifier.")
        }
    }
    
    
}

extension BusinessesViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        businessesStore.businesses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BusinessCell") as! BusinessTableCell
        
        let business = businessesStore.businesses[indexPath.row]
        
        // Set name and phone of cell label
        cell.businessName.text = business.name
        cell.phoneNumber.text = business.displayPhone
        
        // Get reviews
        let reviews = business.reviewCount
        cell.reviews.text = String(reviews)
        
        // Get categories
        let categorie = business.categories[0].title
        cell.category.text = categorie
        
        // Set stars images
        let reviewDouble = business.rating
        cell.starsImage.image = Stars.dict[reviewDouble]!
        
        // Set Image of restaurant
        let imageUrlString = business.imageURL
        if let imageUrl = URL(string: imageUrlString) {
            cell.businessImage.load(url: imageUrl)
        }
    
        return cell

    }
    
}

extension UIImageView {
    func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}

extension BusinessesViewController: LocationServiceDelegate {
    
    func tracingLocation(currentLocation: CLLocation) {
        getWeatherInformation(latitude: currentLocation.coordinate.latitude, longitude: currentLocation.coordinate.longitude)
        businessesStore.loadBusinessesForLocation(lat: currentLocation.coordinate.latitude, lon: currentLocation.coordinate.longitude)
    }
}

extension BusinessesViewController: MapViewDelegate {
    
    func getBusinessesForPinnedLocation(cordinates: CLLocationCoordinate2D) {
        loadBusinessesForPinnedLocation(cordinates: cordinates)
    }

}
