//
//  BusinessDetail.swift
//  FoodyWeather
//
//  Created by Abdullah Alseddiq on 12/18/20.
//

import Foundation

// MARK: - BusniessDetailsResponse
struct BusinessDetail: Codable {
//    let id, alias, name: String
//    let imageURL: String
    let isClaimed, isClosed: Bool
//    let url: String
//    let phone, displayPhone: String
//    let reviewCount: Int
//    let categories: [BusniessCategory]
//    let rating: Double
//    let location: BusniessLocation
//    let coordinates: Coordinates
    let photos: [String]
//    let price: String
    let hours: [Hour]
//    let specialHours: [SpecialHour]

    enum CodingKeys: String, CodingKey {
//        case id, alias, name
//        case imageURL = "image_url"
        case isClaimed = "is_claimed"
        case isClosed = "is_closed"
//        case url, phone
//        case displayPhone = "display_phone"
//        case reviewCount = "review_count"
//        case categories, rating, location, coordinates, photos, price, hours
//        case specialHours = "special_hours"
        case photos
        case hours
    }
}


// MARK: - Hour
struct Hour: Codable {
    let hourOpen: [Open]
    let hoursType: String
    let isOpenNow: Bool

    enum CodingKeys: String, CodingKey {
        case hourOpen = "open"
        case hoursType = "hours_type"
        case isOpenNow = "is_open_now"
    }
}

// MARK: - Open
struct Open: Codable {
    let isOvernight: Bool
    let start, end: String
    let day: Int

    enum CodingKeys: String, CodingKey {
        case isOvernight = "is_overnight"
        case start, end, day
    }
}


