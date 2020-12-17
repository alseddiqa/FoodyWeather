//
//  BusinessStore.swift
//  FoodyWeather
//
//  Created by Abdullah Alseddiq on 12/17/20.
//

import Foundation

class BusinessStore {
    
    var businesses = [Business]()
    
    init() {
        loadBusinessesForLocation()
    }
    
    func loadBusinessesForLocation() {
        let nc = NotificationCenter.default
        let yelpApi = YelpAPI(lat: 37.7670169511878, lon: -122.42184275)
        yelpApi.getBusinessListForLocation() { (restaurants) in
            guard let restaurants = restaurants else {
                return
            }
            self.businesses = restaurants
            nc.post(name: .businessesLoadedYelp, object: self)
        }
    }
}

extension Notification.Name {
    static let businessesLoadedYelp = Notification.Name(rawValue: "businessesLoadedYelp")
}

