//
//  SaveOperation.swift
//  FoodyWeather
//
//  Created by Abdullah Alseddiq on 12/24/20.
//

import Foundation

import Foundation

class SaveOperation: Operation {
    
    let businessList: [SavedBusiness]
    let url: URL
    
    init(items: [SavedBusiness], url: URL) {
        self.businessList = items
        self.url = url
    }
    
    private func save() {
        do {
            let encoder = PropertyListEncoder()
            let data = try encoder.encode(businessList)
            try data.write(to: url)
        } catch let encodingError {
            print("Error encoding businessList: \(encodingError)")
        }
    }
    
    override func main() {
        save()
    }
}
