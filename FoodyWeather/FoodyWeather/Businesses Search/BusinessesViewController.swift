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

    var businessesStore: BusinessesFetcher!
    var userLocationManager: UserLocationService!
    var currentLocationStatus: Bool = true
    var savedBusinesses: BusinessStorage!
    var connectedToWifi: Bool = true
    var weatherForcast: WeatherResult!
    var currentLocation: CLLocationCoordinate2D!
    
    @IBOutlet var searchButton: UIButton!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var searchTextField: UITextField!
    @IBOutlet var weatherImage: UIImageView!
    @IBOutlet var tempratureLabel: UILabel!
    @IBOutlet var weatherConditionLabel: UILabel!
    @IBOutlet var locationButton: UIButton!
    @IBOutlet var spinner: UIActivityIndicatorView!
    @IBOutlet var locationIcon: UIImageView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        tempratureLabel.blink()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        spinner.startAnimating()
        savedBusinesses = BusinessStorage()
        checkInternetConnection()
        

        locationIcon.isHidden = true
        
        if connectedToWifi == true {
            userLocationManager = UserLocationService()
            userLocationManager.delegate = self
            businessesStore = BusinessesFetcher()
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
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(observeDiskLoad(note:)),
                                               name: .loadFromDisk,
                                               object: nil)
    }
    
    @objc func observeDiskLoad(note: Notification) {
        tableView.reloadData()
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
        savedBusinesses.storeLastSeatch(businesses: businessesStore.businesses)
    }
    
    func setUpSubView() {
        searchTextField.layer.cornerRadius = 15.0
        searchTextField.layer.borderWidth = 1.0
        searchTextField.layer.borderColor = #colorLiteral(red: 0.3086441457, green: 0.5725629926, blue: 0.4548408389, alpha: 1)
        searchTextField.layer.masksToBounds = true
    }
    
    @IBAction func searchRestaurant(_ sender: UIButton) {
        let searchKeyWord = searchTextField.text
        businessesStore.searchForBusiness(restaurant: searchKeyWord!, lat: currentLocation.latitude, lon: currentLocation.longitude)
    }
    
    func loadBusinessesForPinnedLocation(cordinates: CLLocationCoordinate2D) {
        businessesStore.loadBusinessesForLocation(lat: cordinates.latitude, lon: cordinates.longitude)
        self.getWeatherInformation(latitude: cordinates.latitude, longitude: cordinates.longitude)
    }
    
    func loadBusinessFromDisk() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
            self.spinner.stopAnimating()
            self.spinner.isHidden = true
            self.weatherConditionLabel.text = "Your Last search!"
            self.searchTextField.isEnabled = false
            self.locationIcon.image = UIImage(systemName: "wifi.slash")
            self.locationIcon.isHidden = false
            self.searchTextField.isHidden = true
            self.searchButton.isHidden = true
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
        let keyWord = textField.text!
        businessesStore.searchForBusiness(restaurant: keyWord, lat: currentLocation.latitude, lon: currentLocation.longitude)
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
        let cordinates = CLLocationCoordinate2D(latitude: currentLocation.coordinate.latitude, longitude: currentLocation.coordinate.longitude)
        self.currentLocation = cordinates
    }
}

extension BusinessesViewController: MapViewDelegate {
    
    func getBusinessesForPinnedLocation(cordinates: CLLocationCoordinate2D) {
        loadBusinessesForPinnedLocation(cordinates: cordinates)
        self.currentLocation = cordinates
    }

}
