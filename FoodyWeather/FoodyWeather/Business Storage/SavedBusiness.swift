//
//  SavedBusiness.swift
//  FoodyWeather
//
//  Created by Abdullah Alseddiq on 12/24/20.
//

import Foundation

class SavedBusiness: Equatable, Codable {
    
    static func == (lhs: SavedBusiness, rhs: SavedBusiness) -> Bool {
        return lhs.id == rhs.id && lhs.name == rhs.name
    }
    
    var id, name, displayPhone, businessCategory: String
    let reviewCount: Int
    let businessRating: Double
    let location: Location
    let imageURL: String
    var businessHours = [Open]()
    var forcastDays = [Forecastday]()
    var businessPhotos = [URL]()
    
    init(name: String, businessId: String, reviewCount: Int, businessLocation: Location, category: String, rating: Double, phone: String, imageURL: String) {
        self.name = name
        self.id = businessId
        self.reviewCount = reviewCount
        self.location = businessLocation
        self.businessCategory = category
        self.businessRating = rating
        self.displayPhone = phone
        self.imageURL = imageURL
    }
    
}
