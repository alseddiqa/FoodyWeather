//
//  MapViewController.swift
//  FoodyWeather
//
//  Created by Abdullah Alseddiq on 12/20/20.
//

import UIKit
import MapKit

class MapViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet var tableView: UITableView!
    @IBOutlet var mapView: MKMapView!
    @IBOutlet var searchCityTextField: UITextField!
    
    var results = [SearchResult]()
    
    var annotaionsCounter: Int = 0
    var mapDelegate: MapViewDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        // Do any additional setup after loading the view.
        //setUpMapView()
    }
    
    func setUpMapView() {
        
        let standardString = NSLocalizedString("Standard", comment: "Standard map view")
        let hybridString = NSLocalizedString("Hybrid", comment: "Hybrid map view")
        let satelliteString = NSLocalizedString("Satellite", comment: "Satellite map view")
        
        let segmentedControl
            = UISegmentedControl(items: [standardString, hybridString, satelliteString])
        segmentedControl.backgroundColor = UIColor.systemBackground
        segmentedControl.selectedSegmentIndex = 0
        
        segmentedControl.addTarget(self, action: #selector(mapTypeChanged(_:)), for: .valueChanged)
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(segmentedControl)
        
        let topConstraint = segmentedControl.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8)
        
        let margins = view.layoutMarginsGuide
        let leadingConstraint = segmentedControl.leadingAnchor.constraint(equalTo: margins.leadingAnchor)
        let trailingConstraint = segmentedControl.trailingAnchor.constraint(equalTo: margins.trailingAnchor)
        
        topConstraint.isActive = true
        leadingConstraint.isActive = true
        trailingConstraint.isActive = true
    }
    
    @objc func  mapTypeChanged(_ segControl: UISegmentedControl){
        switch segControl.selectedSegmentIndex {
        case 0:
            mapView.mapType = .standard
        case 1:
            mapView.mapType = .hybrid
        case 2:
            mapView.mapType = .satellite
        default:
            break
        }
    }
    
    @IBAction func triggerTouchAction(_ sender: UITapGestureRecognizer){
        if sender.state == .ended{
            let locationInView = sender.location(in: mapView)
            let tappedCoordinate = mapView.convert(locationInView, toCoordinateFrom: mapView)
            
            //Making sure only one annotation is placed on the map
            if annotaionsCounter == 1 {
                mapView.removeAnnotations(mapView.annotations)
                annotaionsCounter = 0
                addAnnotation(coordinate: tappedCoordinate)
            }
            else {
                mapView.removeAnnotations(mapView.annotations)
                addAnnotation(coordinate: tappedCoordinate)
                annotaionsCounter+=1
            }
        }
    }
    
    /// A function that adds annotion on map for the sent cordinates where the user tapped
    /// - Parameter coordinate: location of where the user tapped
    func addAnnotation(coordinate:CLLocationCoordinate2D){
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        mapView.addAnnotation(annotation)
        showPinnedLocationPhotos(coordinate: coordinate)
    }
    
    /// A function that pops the VC to show the list of businesses for the pinned location
    /// - Parameter coordinate: the location where the user tapped -> location of the annoation
    func showPinnedLocationPhotos(coordinate: CLLocationCoordinate2D)
    {
        mapDelegate.getBusinessesForPinnedLocation(cordinates: coordinate)
        self.navigationController?.popViewController(animated: true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func sendForAutoComplete(_ word: String) {
        WeatherAPI.getSearchAutoComplete(keyWord: word)
        { (weatherResult) in
            guard let weatherResult = weatherResult else {
                return
            }
            self.results = weatherResult
            self.tableView.reloadData()
        }
    }
    
    @IBAction func handleCitySearch(_ sender: UITextField) {
        let textCount = sender.text?.count
        if textCount == 0 {
            self.tableView.isHidden = true
        }
        else {
            self.tableView.isHidden = false
            let keyWord = sender.text
            self.sendForAutoComplete(keyWord!)
        }
    }
    
}

extension MapViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return results.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "searchCell") as! SearchResultCell

        let result = results[indexPath.row]
        cell.locationName.text = result.name
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCity = results[indexPath.row]
        
        let lat = selectedCity.lat
        let long = selectedCity.lon
        let corindates = CLLocationCoordinate2D(latitude: lat, longitude: long)
        mapDelegate.getBusinessesForPinnedLocation(cordinates: corindates)
        self.navigationController?.popViewController(animated: true)
    }

}

extension UITableView {
    
    /// A function that sets a message for the table view to display when there are no cells
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

