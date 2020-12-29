//
//  BusinessesFetcher.swift
//  FoodyWeather
//
//  Created by Abdullah Alseddiq on 12/17/20.
//

import Foundation

class BusinessesFetcher {
    
    var businesses = [Business]()
    
    init() {
        
    }
    
    /// A helper function to execute businesses load for a specific location
    /// - Parameters:
    ///   - lat: the latitude of the location
    ///   - lon: the logintitude of the location
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
    
    /// A function to execute a search for a restaurant
    /// - Parameters:
    ///   - restaurant: the search keyword
    ///   - lat: latitude of the specified location
    ///   - lon: lonitude of the specified location
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
    static let loadFromDisk = Notification.Name(rawValue: "loadFromDisk")
}

