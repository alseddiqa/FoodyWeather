//
//  Extensions+BusinessesViewController.swift
//  FoodyWeather
//
//  Created by Abdullah Alseddiq on 12/29/20.
//

import Foundation
import UIKit
import CoreLocation

extension BusinessesViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if connectedToWifi == false {
            if savedBusinesses.businessList.count == 0 {
                self.tableView.setEmptyMessage("No data available! check internet")
            }
            return savedBusinesses.businessList.count
        }
        else {
            return businessesStore.businesses.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BusinessCell") as! BusinessTableCell
        
        if connectedToWifi {
            let business = businessesStore.businesses[indexPath.row]
            
            // Set name and phone of cell label
            cell.businessName.text = business.name
            cell.phoneNumber.text = business.displayPhone
            
            // Get reviews
            let reviews = business.reviewCount
            cell.reviews.text = String(reviews)
            
            // Get categories
            let categorie = business.categories[0].title
            cell.category.text = categorie
            
            // Set stars images
            let reviewDouble = business.rating
            cell.starsImage.image = Stars.dict[reviewDouble]!
            
            // Set Image of restaurant
            let imageUrlString = business.imageURL
            if let imageUrl = URL(string: imageUrlString) {
    //            cell.businessImage.load(url: imageUrl)
                cell.businessImage.kf.setImage(with: imageUrl)
            }
        }else {
            let business = savedBusinesses.businessList[indexPath.row]
            
            // Set name and phone of cell label
            cell.businessName.text = business.name
            cell.phoneNumber.text = business.displayPhone
            
            // Get reviews
            let reviews = business.reviewCount
            cell.reviews.text = String(reviews)
            
            // Get categories
            let categorie = business.businessCategory
            cell.category.text = categorie
            
            // Set stars images
            let reviewDouble = business.businessRating
            cell.starsImage.image = Stars.dict[reviewDouble]!
            
            // Set Image of restaurant
            let imageUrlString = URL(string: business.imageURL)
            cell.businessImage.kf.setImage(with: imageUrlString)
        }
        
        return cell

    }
    
}

extension BusinessesViewController: LocationServiceDelegate {
    
    func tracingLocation(currentLocation: CLLocation) {
        getWeatherInformation(latitude: currentLocation.coordinate.latitude, longitude: currentLocation.coordinate.longitude)
        businessesStore.loadBusinessesForLocation(lat: currentLocation.coordinate.latitude, lon: currentLocation.coordinate.longitude)
        let cordinates = CLLocationCoordinate2D(latitude: currentLocation.coordinate.latitude, longitude: currentLocation.coordinate.longitude)
        self.currentLocation = cordinates
    }
}

extension BusinessesViewController: MapViewDelegate {
    
    func getBusinessesForPinnedLocation(cordinates: CLLocationCoordinate2D) {
        loadBusinessesForPinnedLocation(cordinates: cordinates)
        self.currentLocation = cordinates
    }

}
