//
//  SearchResult.swift
//  FoodyWeather
//
//  Created by Abdullah Alseddiq on 12/26/20.
//


import Foundation

//Codable class for location autocomplete from the weather api

// MARK: - Search result
struct SearchResult: Codable {
    let id: Int
    let name: String
    let region: String
    let country: String
    let lat, lon: Double
    let url: String
}

typealias SearchResultList = [SearchResult]
