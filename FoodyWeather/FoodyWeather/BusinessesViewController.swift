//
//  BusinessesViewController.swift
//  FoodyWeather
//
//  Created by Abdullah Alseddiq on 12/16/20.
//

import UIKit
import CoreLocation
import Kingfisher
import Network

class BusinessesViewController: UIViewController , UITextFieldDelegate{

    var businessesStore: BusinessStore!
    var userLocationManager: UserLocationService!
    var currentLocationStatus: Bool = true
    var savedBusinesses: BusinessStorage!
    var connectedToWifi: Bool = true
    var weatherForcast: WeatherResult!

    @IBOutlet var tableView: UITableView!
    @IBOutlet var searchTextField: UITextField!
    @IBOutlet var weatherImage: UIImageView!
    @IBOutlet var tempratureLabel: UILabel!
    @IBOutlet var weatherConditionLabel: UILabel!
    @IBOutlet var locationButton: UIButton!
    @IBOutlet var spinner: UIActivityIndicatorView!
    @IBOutlet var locationIcon: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        spinner.startAnimating()
        
        savedBusinesses = BusinessStorage()
        checkInternetConnection()
        

        locationIcon.isHidden = true
        
        if connectedToWifi == true {
            userLocationManager = UserLocationService()
            userLocationManager.delegate = self

            businessesStore = BusinessStore()
        }
        
        
        tableView.delegate = self
        tableView.dataSource = self
        
        observeLoadNotifications()

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
            spinner.stopAnimating()
            spinner.isHidden = true
            locationIcon.isHidden = false
            
        }
    }
    
    func checkInternetConnection(){
        let monitor = NWPathMonitor()
        
        monitor.pathUpdateHandler = { path in
            if path.status != .satisfied {
                // Not connected
                print("not connected to internet")
                self.connectedToWifi = false
                //nc.post(name: .noConnection, object: self)
                self.loadBusinessFromDisk()
            }
            else if path.usesInterfaceType(.cellular) {
                // Cellular 3/4/5g connection
            }
            else if path.usesInterfaceType(.wifi) {
                // Wi-fi connection
            }
            else if path.usesInterfaceType(.wiredEthernet) {
                // Ethernet connection
            }
        }
         
        monitor.start(queue: DispatchQueue.global(qos: .background))
         
    }
    
    func observeLoadNotifications() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(observeStoreLoadNotification(note:)),
                                               name: .businessesLoadedYelp,
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(observeStoreSearchNotificataion(note:)),
                                               name: .businessesSearchYelp,
                                               object: nil)
        
//        NotificationCenter.default.addObserver(self,
//                                               selector: #selector(loadBusinessFromDisk(note:)),
//                                               name: .noConnection,
//                                               object: nil)
    }
    
    @objc func observeStoreSearchNotificataion(note: Notification) {
        tableView.reloadData()
        if businessesStore.businesses.count != 0 {
            let city = businessesStore.businesses[0].location.city
            let state = businessesStore.businesses[0].location.state
            if state.count != 0 && city.count != 0 {
                let location = city + "," + state
                locationButton.setTitle(location, for: .application)
            }
            spinner.stopAnimating()
            spinner.isHidden = true
            locationIcon.isHidden = false
            
        }
        storeSearchResults()
    }
    
    func getWeatherInformation(latitude: Double, longitude: Double) {
        let latAndLong = String(latitude) + "," + String(longitude)
        WeatherAPI.getWeatherForLocation(location: latAndLong)
        { (weatherResult) in
            guard let weatherResult = weatherResult else {
                return
            }
            if let weatherIconUrl = URL(string: "http:" + weatherResult.current.condition.icon) {
                self.weatherImage.load(url: weatherIconUrl)
            }
            //self.cityLabel.text = weatherResult.location.name
            self.locationButton.setTitle(weatherResult.location.name, for: .normal)
            let temp = Double(round(100*weatherResult.current.tempC)/100)
            self.tempratureLabel.text = String(temp) + "°C"
            self.weatherConditionLabel.text = weatherResult.current.condition.text
        }
    }
    
    func storeSearchResults() {
        let list = businessesStore.businesses
        if businessesStore.businesses.count != 0 {
            for b in list {
                let business = SavedBusiness(name: b.name, businessId: b.id, reviewCount: b.reviewCount, businessLocation: b.location, category: b.categories[0].title, rating: b.rating, phone: b.displayPhone, imageURL: b.imageURL)
                savedBusinesses.addBusiness(business)                
            }
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
    
    func loadBusinessFromDisk() {
        DispatchQueue.main.async {
            //self.savedBusinesses.businessList.reverse()
            self.tableView.reloadData()
            self.spinner.stopAnimating()
            self.spinner.isHidden = true
            self.weatherConditionLabel.text = "no internet connection"
        }
    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "BusinessDetail":
            if let selectedIndexPath =
                tableView.indexPathForSelectedRow?.row {
                if connectedToWifi {
                    let business = businessesStore.businesses[selectedIndexPath]
                    let destinationVC = segue.destination as! BusinessDetailViewController
                    destinationVC.business = business
                    destinationVC.businessStorage = savedBusinesses
                }
                else {
                    let business = savedBusinesses.businessList[selectedIndexPath]
                    let destinationVC = segue.destination as! BusinessDetailViewController
                    destinationVC.savedBusiness = business
                }
            }
        case "MapViewSegue":
            let destinationVC = segue.destination as! MapViewController
            destinationVC.mapDelegate = self
        
        default:
            preconditionFailure("Unexpected segue identifier.")
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}

extension BusinessesViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if connectedToWifi == false {
            if savedBusinesses.businessList.count == 0 {
                self.tableView.setEmptyMessage("No data available! check internet")
            }
            return savedBusinesses.businessList.count
        }
        else {
            if businessesStore.businesses.count == 0 {
                self.tableView.setEmptyMessage("No data available!")
            }
            return businessesStore.businesses.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BusinessCell") as! BusinessTableCell
        
        if connectedToWifi {
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
    //            cell.businessImage.load(url: imageUrl)
                cell.businessImage.kf.setImage(with: imageUrl)
            }
        }else {
            let business = savedBusinesses.businessList[indexPath.row]
            
            // Set name and phone of cell label
            cell.businessName.text = business.name
            cell.phoneNumber.text = business.displayPhone
            
            // Get reviews
            let reviews = business.reviewCount
            cell.reviews.text = String(reviews)
            
            // Get categories
            let categorie = business.businessCategory
            cell.category.text = categorie
            
            // Set stars images
            let reviewDouble = business.businessRating
            cell.starsImage.image = Stars.dict[reviewDouble]!
            
            // Set Image of restaurant
            let imageUrlString = URL(string: business.imageURL)
            cell.businessImage.kf.setImage(with: imageUrlString)
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

extension UITableView {
    
    /// A function that sets a message for the table view to display when there are no tasks
    /// - Parameter message: the message to display
    func setEmptyMessage(_ message: String) {
        let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height))
        messageLabel.text = message
        messageLabel.textColor = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        messageLabel.font = UIFont(name: "TrebuchetMS", size: 15)
        messageLabel.sizeToFit()
        
        self.backgroundView = messageLabel
        self.separatorStyle = .none
    }
    
    /// A function that restores the table seprator
    func restore() {
        self.backgroundView = nil
        self.separatorStyle = .singleLine
    }
}
