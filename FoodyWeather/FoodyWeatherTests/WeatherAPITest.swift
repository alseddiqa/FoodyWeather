//
//  WeatherAPITest.swift
//  FoodyWeatherTests
//
//  Created by Abdullah Alseddiq on 12/30/20.
//

import XCTest
@testable import FoodyWeather

class WeatherAPITest: XCTestCase {

    func testWeatherUrlBuild() {
        let url = WeatherAPI.getWeatherUrl(location: "San Jose", search: true)
        
        let expected = "http://api.weatherapi.com/v1/search.json?key=96e182aa893140daa75163258201712&q=San%20Jose"
        
        XCTAssertEqual(url.absoluteString, expected)
        
               
    }

}
