//
//  Business.swift
//  FoodyWeather
//
//  Created by Abdullah Alseddiq on 12/16/20.
//

import Foundation

// MARK: - Empty
struct Result: Codable {
    let businesses: [Business]
    let total: Int
    let region: Region
}

// MARK: - Business
struct Business: Codable {
    let id, alias, name: String
    let imageURL: String
    let isClosed: Bool
    let url: String
    let reviewCount: Int
    let categories: [Category]
    let rating: Int
    let coordinates: Center
    let transactions: [String]
    let price: String
    let location: Location
    let phone, displayPhone: String
    let distance: Double

    enum CodingKeys: String, CodingKey {
        case id, alias, name
        case imageURL = "image_url"
        case isClosed = "is_closed"
        case url
        case reviewCount = "review_count"
        case categories, rating, coordinates, transactions, price, location, phone
        case displayPhone = "display_phone"
        case distance
    }
}

// MARK: - Category
struct Category: Codable {
    let alias, title: String
}

// MARK: - Center
struct Center: Codable {
    let latitude, longitude: Double
}

// MARK: - Location
struct Location: Codable {
    let address1, address2, address3, city: String
    let zipCode, country, state: String
    let displayAddress: [String]

    enum CodingKeys: String, CodingKey {
        case address1, address2, address3, city
        case zipCode = "zip_code"
        case country, state
        case displayAddress = "display_address"
    }
}

// MARK: - Region
struct Region: Codable {
    let center: Center
}
