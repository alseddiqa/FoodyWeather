//
//  BusinessDetail.swift
//  FoodyWeather
//
//  Created by Abdullah Alseddiq on 12/18/20.
//

import Foundation

// MARK: - BusniessDetailsResponse
struct BusinessDetail: Codable {
    let isClaimed, isClosed: Bool
    let photos: [String]
    let hours: [Hour]


    enum CodingKeys: String, CodingKey {
        case isClaimed = "is_claimed"
        case isClosed = "is_closed"
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


