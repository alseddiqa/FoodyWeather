//
//  BusinessStorage.swift
//  FoodyWeather
//
//  Created by Abdullah Alseddiq on 12/24/20.
//

import Foundation
import UIKit

/// A storage class to store the last businesses search
class BusinessStorage {

    var businessList = [SavedBusiness]()
    
    /// Operation Queue upon which SaveOperation and LoadOperation instances will be executed for loading/saving the last search result by businesses  made by the user.
    private let diskIOQueue: OperationQueue = {
        let queue = OperationQueue()
        queue.maxConcurrentOperationCount = 1
        return queue
    }()
    
    /// the url path to store last search in
    let businessArchiveURL: URL = {
        let documentsDirectories =
            FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentDirectory = documentsDirectories.first!
        return documentDirectory.appendingPathComponent("Businesses.plist")
    }()
    
    init() {
        let nc = NotificationCenter.default
        
        let loadOp = BusinessLoadOperation(url: businessArchiveURL) { (items) in
            self.businessList = items
            print("list Loaded~!")
            nc.post(name: .loadFromDisk, object: self)
        }
        diskIOQueue.addOperation(loadOp)

        nc.addObserver(self,
                       selector: #selector(saveChanges),
                       name: UIApplication.didEnterBackgroundNotification,
                       object: nil)
    }
    
    /// A function to to add business to the list
    /// - Parameter business: the business to add
    func addBusiness(_ business: SavedBusiness){
        businessList.append(business)
    }
    
    /// A helper function to remove item from the list
    /// - Parameter business: the business to remove
    func removeItem(_ business: SavedBusiness) {
        if let index = businessList.firstIndex(of: business) {
            businessList.remove(at: index)
        }
    }
    
    /// A function to update information for a business
    /// - Parameters:
    ///   - oldBusiness: old business information
    ///   - newBusiness: new business information
    func updateBusinessInformaton(oldBusiness: SavedBusiness, newBusiness: SavedBusiness ) {
        if let indexOfOld = businessList.firstIndex(of: oldBusiness)
        {
            businessList[indexOfOld] = newBusiness
        }
    }
    
    /// A function to store the photos for business if viewed
    /// - Parameters:
    ///   - businessId: the business id
    ///   - photos: photos to store locally
    func updatePhotosForBusiness(businessId: String, photos: [URL]) {
        if businessList.count != 0 {
            for (index, b) in businessList.enumerated() {
                if b.id == businessId {
                    businessList[index].businessPhotos = photos
                }
            }
        }
    }
    
    /// A function to store operating hours for business if viewed
    /// - Parameters:
    ///   - businessId: the business id
    ///   - hours: the hours to store for business
    func updateHoursForBusiness(businessId: String, hours: [Open]) {
        if businessList.count != 0 {
            for (index, b) in businessList.enumerated() {
                if b.id == businessId {
                    businessList[index].businessHours = hours
                }
            }
        }
    }
    
    /// A function to store 3-days forcast for a business
    /// - Parameters:
    ///   - businessId: the business id
    ///   - forcast: the forcast days
    func updateForcastForBusiness(businessId: String, forcast: [Forecastday]) {
        if businessList.count != 0 {
            for (index, b) in businessList.enumerated() {
                if b.id == businessId {
                    businessList[index].forcastDays = forcast
                }
            }
        }
    }
    
    /// A function to store the reviews for a specific business that is viewed
    /// - Parameters:
    ///   - businessId: the business id
    ///   - reviews: the reviews retrieved for the business
    func updateReviewsForBusiness(businessId: String, reviews: [Review]) {
        if businessList.count != 0 {
            for (index, b) in businessList.enumerated() {
                if b.id == businessId {
                    businessList[index].businessReviews = reviews
                }
            }
        }
    }
    
    /// To execute the save to locally
    @objc func saveChanges() {
        print("Saving items to: \(businessArchiveURL)")
        let saveOp = SaveOperation(items: businessList, url: businessArchiveURL)
        diskIOQueue.addOperation(saveOp)
    }
    
    /// A helper function to store the latest search result
    /// - Parameter businesses: list of businesses to store
    func storeLastSeatch(businesses: [Business]) {
        if businesses.count != 0 {
            self.businessList.removeAll()
            for b in businesses {
                let business = SavedBusiness(name: b.name, businessId: b.id, reviewCount: b.reviewCount, businessLocation: b.location, category: b.categories[0].title, rating: b.rating, phone: b.displayPhone, imageURL: b.imageURL)
                self.addBusiness(business)
            }
        }
    }

}
