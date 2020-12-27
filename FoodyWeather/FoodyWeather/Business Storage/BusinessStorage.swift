//
//  BusinessStorage.swift
//  FoodyWeather
//
//  Created by Abdullah Alseddiq on 12/24/20.
//

import Foundation
import UIKit

class BusinessStorage {

    var businessList = [SavedBusiness]()
    
    /// Operation Queue upon which SaveOperation and LoadOperation instances will be executed for loading/saving the items array.
    private let diskIOQueue: OperationQueue = {
        let queue = OperationQueue()
        queue.maxConcurrentOperationCount = 1
        return queue
    }()
    
    let itemArchiveURL: URL = {
        let documentsDirectories =
            FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentDirectory = documentsDirectories.first!
        return documentDirectory.appendingPathComponent("Businesses.plist")
    }()
    
    init() {
        let nc = NotificationCenter.default
        let loadOp = BusinessLoadOperation(url: itemArchiveURL) { (items) in
            self.businessList = items
            print("list Loaded~!")
        }
        diskIOQueue.addOperation(loadOp)

        nc.addObserver(self,
                       selector: #selector(saveChanges),
                       name: UIApplication.didEnterBackgroundNotification,
                       object: nil)
    }
        
    func addBusiness(_ business: SavedBusiness){
        businessList.append(business)
    }
    
    func removeItem(_ business: SavedBusiness) {
        if let index = businessList.firstIndex(of: business) {
            businessList.remove(at: index)
        }
    }
    
    func updateBusinessInformaton(oldBusiness: SavedBusiness, newBusiness: SavedBusiness ) {
        if let indexOfOld = businessList.firstIndex(of: oldBusiness)
        {
            businessList[indexOfOld] = newBusiness
        }
    }
    
    func updatePhotosForBusiness(businessId: String, photos: [URL]) {
        if businessList.count != 0 {
            for (index, b) in businessList.enumerated() {
                if b.id == businessId {
                    businessList[index].businessPhotos = photos
                }
            }
        }
    }
    
    func updateHoursForBusiness(businessId: String, hours: [Open]) {
        if businessList.count != 0 {
            for (index, b) in businessList.enumerated() {
                if b.id == businessId {
                    businessList[index].businessHours = hours
                }
            }
        }
    }
    
    func updateForcastForBusiness(businessId: String, forcast: [Forecastday]) {
        if businessList.count != 0 {
            for (index, b) in businessList.enumerated() {
                if b.id == businessId {
                    businessList[index].forcastDays = forcast
                }
            }
        }
    }

    @objc func saveChanges() {
        print("Saving items to: \(itemArchiveURL)")
        let saveOp = SaveOperation(items: businessList, url: itemArchiveURL)
        diskIOQueue.addOperation(saveOp)
    }
    
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
