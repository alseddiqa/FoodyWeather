//
//  BusinessStorage.swift
//  FoodyWeather
//
//  Created by Abdullah Alseddiq on 12/24/20.
//

import Foundation

class BusinessStorage {
    
    var businessesList = [SavedBusiness]()
    
    let itemArchiveURL: URL = {
        let documentsDirectories =
            FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentDirectory = documentsDirectories.first!
        return documentDirectory.appendingPathComponent("businesses.plist")
    }()
    
    func addBusiness(_ business: SavedBusiness) {
        businessesList.append(business)
    }
    
    func removeBusiness(_ business: SavedBusiness) {
        if let index = businessesList.firstIndex(of: business) {
            businessesList.remove(at: index)
        }
    }

    @objc func saveChanges() -> Bool {        
        do {
            let encoder = PropertyListEncoder()
            let data = try encoder.encode(businessesList)
            try data.write(to: itemArchiveURL)
            print("Saved businesses list")
            return true
        } catch let encodingError {
            print("Error encoding list: \(encodingError)")
            return false
        }
    }
    
}
