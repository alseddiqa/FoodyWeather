//
//  YelpAPITests.swift
//  FoodyWeatherTests
//
//  Created by Abdullah Alseddiq on 12/30/20.
//

import XCTest
@testable import FoodyWeather


class YelpAPITests: XCTestCase {
    
    func testYelpStars() {
        let rating = 5.0
        let image = Stars.dict[rating]!
        XCTAssertEqual(image, UIImage(named: "regular_5"))
        
    }

    func testUrlBuildForSearch() {
        let searchKeyWord = "pizza"
        let lat = 37.767016
        let lon = -122.421842
        let expectedURL = "https://api.yelp.com/v3/businesses/search?longitude=-122.421842&term=pizza&latitude=37.767016"
        
        let url = YelpAPI.getYelpUrl(latitude: String(lat), longitude: String(lon), keyWord: searchKeyWord, search: true)
        XCTAssertEqual(expectedURL, url.absoluteString)
        

    }
    
    func testUrlBuildForLocationBusinesses() {
        let lat = 37.767016
        let lon = -122.421842
        let expectedURL = "https://api.yelp.com/v3/businesses/search?longitude=-122.421842&latitude=37.767016"
        
        let url = YelpAPI.getYelpUrl(latitude: String(lat), longitude: String(lon), search: false)
        XCTAssertEqual(expectedURL, url.absoluteString)
        
    }
    
    

}
