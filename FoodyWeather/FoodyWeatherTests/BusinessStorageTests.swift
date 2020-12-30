//
//  BusinessStorageTests.swift
//  FoodyWeatherTests
//
//  Created by Abdullah Alseddiq on 12/29/20.
//

import XCTest
@testable import FoodyWeather

class BusinessStorageTests: XCTestCase {

    func testBusinessUpdateInStorage() {
        let businessStore = BusinessStorage()
        
        let location = Location(address1: "111", address2: "111", address3: "111", city: "111", zipCode: "111", country: "111", state: "!11", displayAddress: ["123"])
        let business = SavedBusiness(name: "My Business", businessId: "123", reviewCount: 5, businessLocation: location, category: "burger", rating: 5, phone: "0001110001", imageURL: "url")
        
        businessStore.addBusiness(business)

        let myBusiness = business
        myBusiness.name = "the best"
        
        businessStore.updateBusinessInformaton(oldBusiness: business, newBusiness: myBusiness)
        
        let b = businessStore.businessList[0]
        XCTAssertEqual(b.name, myBusiness.name)
        
        
    }

    func testBusinessLocations() {
        let businessStore = BusinessesFetcher()
        
        let lat = 37.767016
        let lon = -122.421842
        
        businessStore.loadBusinessesForLocation(lat: 37.767016, lon: -122.421842)
        
        for b in businessStore.businesses {
            XCTAssertEqual(Int(b.coordinates.latitude), Int(lat))
            XCTAssertEqual(Int(b.coordinates.longitude), Int(lon))
        }
    }
    
}
