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
    
    //Declaring outlets for the VC
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
        spinner.stopAnimating()
        spinner.isHidden = true
        locationIcon.isHidden = false
    }
    
    /// A helper function to check internet connectivity, if no connection will show businesses loaded from the disk
    func checkInternetConnection(){
        let monitor = NWPathMonitor()
        
        monitor.pathUpdateHandler = { path in
            if path.status != .satisfied {
                // Not connected
                print("not connected to internet")
                self.connectedToWifi = false
                self.showSavedBusinessFromDisk()
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
    
    /// A helper function to add obervers for load notification from APIs/ or load
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
        spinner.stopAnimating()
        storeSearchResults()
    }
    
    /// A function to the overall weather condition for the current location
    /// - Parameters:
    ///   - latitude: the latitude of the current location
    ///   - longitude: the lonigitude for the current location
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
    
    /// A function to store the last search result made by the user
    func storeSearchResults() {
        savedBusinesses.storeLastSeatch(businesses: businessesStore.businesses)
    }
    
    /// Styling the search textfield
    func setUpSubView() {
        searchTextField.layer.cornerRadius = 15.0
        searchTextField.layer.borderWidth = 1.0
        searchTextField.layer.borderColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        searchTextField.layer.masksToBounds = true
    }
    
    /// A function that execute a search when the user hit the search button
    /// - Parameter sender: search button with icon
    @IBAction func searchRestaurant(_ sender: UIButton) {
        let searchKeyWord = searchTextField.text
        businessesStore.searchForBusiness(restaurant: searchKeyWord!, lat: currentLocation.latitude, lon: currentLocation.longitude)
        spinner.isHidden = false
        spinner.startAnimating()
    }
    
    /// A function that loads the businesses for a specific location when the user changes the current location
    /// - Parameter cordinates: <#cordinates description#>
    func loadBusinessesForPinnedLocation(cordinates: CLLocationCoordinate2D) {
        businessesStore.loadBusinessesForLocation(lat: cordinates.latitude, lon: cordinates.longitude)
        self.getWeatherInformation(latitude: cordinates.latitude, longitude: cordinates.longitude)
    }
    
    /// if there's no wifi, saved business list will be shown
    func showSavedBusinessFromDisk() {
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
    
    /// A function that execute a search when the user hits the return button from the keyboard
    /// - Parameter textField: the text field
    /// - Returns: true when the keyboard is dismissed
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        let keyWord = textField.text!
        businessesStore.searchForBusiness(restaurant: keyWord, lat: currentLocation.latitude, lon: currentLocation.longitude)
        return true
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


