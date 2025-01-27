//
//  UserLocationService.swift
//  FoodyWeather
//
//  Created by Abdullah Alseddiq on 12/19/20.
//

import Foundation
import CoreLocation

protocol LocationServiceDelegate {
    func tracingLocation(currentLocation: CLLocation)
}

class UserLocationService: NSObject, CLLocationManagerDelegate {
    
    //instance of location manager
    private let locationManager = CLLocationManager()
    
    //Declaring lat and long for the current location that will be set when location of the user is determined
    private(set) var latitude = 0.0
    private(set) var longitude = 0.0
    
    var lastLocation: CLLocation?
    var delegate: LocationServiceDelegate?
    
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = kCLDistanceFilterNone
        locationManager.requestAlwaysAuthorization()
//        locationManager.startUpdatingLocation()
        locationManager.startMonitoringSignificantLocationChanges()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            latitude = location.coordinate.latitude
            longitude = location.coordinate.longitude
            
            self.lastLocation = location
                    
            // use for real time update location
            updateLocation(currentLocation: location)
        }
    }
    
    func startUpdatingLocation() {
            print("Starting Location Updates")
            self.locationManager.startUpdatingLocation()
    }
    
    private func updateLocation(currentLocation: CLLocation){

          guard let delegate = self.delegate else {
              return
          }
        
        self.latitude = currentLocation.coordinate.latitude
        self.longitude = currentLocation.coordinate.longitude
          
        delegate.tracingLocation(currentLocation: currentLocation)
    }
    
}
