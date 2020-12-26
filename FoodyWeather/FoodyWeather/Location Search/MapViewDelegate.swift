//
//  MapViewDelegate.swift
//  FoodyWeather
//
//  Created by Abdullah Alseddiq on 12/20/20.
//

import Foundation
import CoreLocation

protocol MapViewDelegate: NSObject {
    func getBusinessesForPinnedLocation(cordinates: CLLocationCoordinate2D)
}
