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
        let otherForm = "https://api.yelp.com/v3/businesses/search?term=pizza&longitude=-122.421842&latitude=37.767016"
        let thirdForm = "https://api.yelp.com/v3/businesses/search?latitude=37.767016&longitude=-122.421842&term=pizza"
        let forthForm = "https://api.yelp.com/v3/businesses/search?longitude=-122.421842&latitude=37.767016&term=pizza"
        
        let url = YelpAPI.getYelpUrl(latitude: String(lat), longitude: String(lon), keyWord: searchKeyWord, search: true)
        
        if expectedURL == url.absoluteString {
            XCTAssertEqual(expectedURL, url.absoluteString)
        } else if otherForm == url.absoluteString {
            XCTAssertEqual(otherForm, url.absoluteString)
        }
        else if thirdForm == url.absoluteString{
            XCTAssertEqual(thirdForm, url.absoluteString)
        }
        else {
            XCTAssertEqual(forthForm, url.absoluteString)
        }

    }
    
    func testUrlBuildForLocationBusinesses() {
        let lat = 37.767016
        let lon = -122.421842
        let expectedURL = "https://api.yelp.com/v3/businesses/search?longitude=-122.421842&latitude=37.767016"
        
        let url = YelpAPI.getYelpUrl(latitude: String(lat), longitude: String(lon), search: false)
        XCTAssertEqual(expectedURL, url.absoluteString)
        
    }

}
