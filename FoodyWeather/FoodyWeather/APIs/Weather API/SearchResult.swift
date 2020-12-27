//
//  SearchResult.swift
//  FoodyWeather
//
//  Created by Abdullah Alseddiq on 12/26/20.
//


import Foundation

// MARK: - Element
struct SearchResult: Codable {
    let id: Int
    let name: String
    let region: String
    let country: String
    let lat, lon: Double
    let url: String
}

typealias SearchResultList = [SearchResult]
