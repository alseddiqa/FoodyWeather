//
//  Business.swift
//  FoodyWeather
//
//  Created by Abdullah Alseddiq on 12/16/20.
//

import Foundation

// MARK: - Empty
struct Result: Codable {
    let total: Int
    let businesses: [Business]
    let region: Region
}


// MARK: - Business
struct Business: Codable {
    let rating: Int
    let price, phone, id, alias: String
    let isClosed: Bool
    let categories: [Category]
    let reviewCount: Int
    let name: String
    let url: String
    let coordinates: Center
    let imageURL: String
    let location: Location
    let distance: Double
    let transactions: [String]

    enum CodingKeys: String, CodingKey {
        case rating, price, phone, id, alias
        case isClosed = "is_closed"
        case categories
        case reviewCount = "review_count"
        case name, url, coordinates
        case imageURL = "image_url"
        case location, distance, transactions
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
    let city, country, address2, address3: String
    let state, address1, zipCode: String

    enum CodingKeys: String, CodingKey {
        case city, country, address2, address3, state, address1
        case zipCode = "zip_code"
    }
}

// MARK: - Region
struct Region: Codable {
    let center: Center
}
