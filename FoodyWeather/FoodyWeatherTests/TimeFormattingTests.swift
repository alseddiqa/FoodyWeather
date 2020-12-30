//
//  TimeFormattingTests.swift
//  FoodyWeatherTests
//
//  Created by Abdullah Alseddiq on 12/30/20.
//

import XCTest
@testable import FoodyWeather

class TimeFormattingTests: XCTestCase {

    func testTimeFormatter(){
        
        let vc = BusinessHoursViewController()
        let hour = vc.getHoursOpen(start: "0303")
        XCTAssertEqual(hour, "3:03 am")
        
        let close = vc.getClosingHour(end: "2030")
        XCTAssertEqual(close, "8:30 pm")
        
    }
    
    func testDayFormatting(){
        
        let vc = BusinessHoursViewController()
        let day = vc.getDayText(day: 5)
        
        XCTAssertEqual(day, "Saturday")
        
    }
    
    func testForcastDate() {
        let vc = WeatherForcastViewController()
        
        let date = "2021-1-1"
        
        let formatted = vc.getDateText(index: 2, dateString: date)
        XCTAssertEqual(formatted, "Jan 1")
    }

}
