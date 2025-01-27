//
//  BusinessLoadOperation.swift
//  FoodyWeather
//
//  Created by Abdullah Alseddiq on 12/24/20.
//

import Foundation

class BusinessLoadOperation: Operation {
    
    var url: URL
    var completionQueue: OperationQueue
    var completion: ([SavedBusiness]) -> Void
    

    init(url: URL,
         thenUpon queue: OperationQueue = .main,
         completion: @escaping ([SavedBusiness]) -> Void) {
        self.url = url
        self.completionQueue = queue
        self.completion = completion
    }
    
    private func load() -> [SavedBusiness] {
        do {
            let data = try Data(contentsOf: url)
            let unarchiver = PropertyListDecoder()
            let items = try unarchiver.decode([SavedBusiness].self, from: data)
            return items
        } catch {
            print("Error reading in saved items: \(error)")
            return []
        }
    }
    
    override func main() {
        let items = load()
        completionQueue.addOperation {
            self.completion(items)
        }
    }
    
}
