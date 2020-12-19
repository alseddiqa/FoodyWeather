//
//  BusinessStore.swift
//  FoodyWeather
//
//  Created by Abdullah Alseddiq on 12/17/20.
//

import Foundation

class BusinessStore {
    
//    let lat = 37.7670169511878
//    let lon = -122.42184275
    
    var businesses = [Business]()
    
    init() {
        
    }
    
    func loadBusinessesForLocation(lat: Double, lon: Double) {
        let nc = NotificationCenter.default
        let yelpApi = YelpAPI(lat: lat, lon: lon)
        yelpApi.getBusinessListForLocation() { (restaurants) in
            guard let restaurants = restaurants else {
                return
            }
            self.businesses = restaurants
            nc.post(name: .businessesLoadedYelp, object: self)
        }
    }
    
    func searchForBusiness(restaurant: String, lat: Double, lon: Double) {
        let nc = NotificationCenter.default
        let yelpApi = YelpAPI(lat: lat, lon: lon)
        yelpApi.getSearchResult(restaurantName: restaurant) { (restaurants) in
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

