//
//  MapViewController.swift
//  FoodyWeather
//
//  Created by Abdullah Alseddiq on 12/20/20.
//

import UIKit
import MapKit

class MapViewController: UIViewController {

    @IBOutlet var mapView: MKMapView!
    var annotaionsCounter: Int = 0
    var mapDelegate: MapViewDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setUpMapView()
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

//        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
//        let destVC = storyboard.instantiateViewController(withIdentifier: "navigationView") as! MainNavigationViewController
//        
//        destVC.modalPresentationStyle = UIModalPresentationStyle.fullScreen
//        destVC.modalTransitionStyle = UIModalTransitionStyle.coverVertical
//        destVC.cordinates = coordinate
//        destVC.currentLocationStatus = false
//        self.dismiss(animated: true, completion: nil)
//        self.present(destVC, animated: true, completion: nil)
    }
}
