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

    @objc func saveChanges() {
        print("Saving items to: \(itemArchiveURL)")
        let saveOp = SaveOperation(items: businessList, url: itemArchiveURL)
        diskIOQueue.addOperation(saveOp)
    }

}
