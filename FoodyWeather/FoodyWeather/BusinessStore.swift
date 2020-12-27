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
        YelpAPI.getBusinessListForLocation(latitude: String(lat), longitude: String(lon)) { (restaurants) in
            guard let restaurants = restaurants else {
                return
            }
            self.businesses = restaurants
            nc.post(name: .businessesLoadedYelp, object: self)
        }
    }
    
    func searchForBusiness(restaurant: String, lat: Double, lon: Double) {
        let nc = NotificationCenter.default
        YelpAPI.getSearchResult(latitude: String(lat), longitude: String(lon), restaurantName: restaurant)
        { (restaurants) in
            guard let restaurants = restaurants else {
                return
            }
            self.businesses = restaurants
            nc.post(name: .businessesSearchYelp, object: self)
        }
    }
}

extension Notification.Name {
    static let businessesLoadedYelp = Notification.Name(rawValue: "businessesLoadedYelp")
    static let businessesSearchYelp = Notification.Name(rawValue: "businessesSearchYelp")
    static let noConnection = Notification.Name(rawValue: "noConnection")

    
}

