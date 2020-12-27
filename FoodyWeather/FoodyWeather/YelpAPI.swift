//
//  YelpAPI.swift
//  FoodyWeather
//
//  Created by Abdullah Alseddiq on 12/16/20.
//

import Foundation

struct YelpAPI {
    
    static let businessDetailbaseURL = "https://api.yelp.com/v3/businesses"
    static let baseURLString = "https://api.yelp.com/v3/businesses/search"
    private static var apiKey = "OP-aAcjnPw7tYtofhaksNCxwZCVg6V2IOJ57UtSasvytaQxWAD3gSqrIY2kuz00Xc1vY9y6DhO3itWS_tP-JIWdV6mP4UNyfNOQMTqJRPyAzeTHMJ9GtZNL9qvrZX3Yx"
    
    /// A function to set up the Yelp URL to get businesses
    /// - Returns: a URL after adding all of the params
    static func getYelpUrl(latitude: String, longitude: String, keyWord: String = "", search: Bool) -> URL {
        
        var baseParams = [String:String]()
        var components = URLComponents(string: baseURLString)!
        var queryItems = [URLQueryItem]()
        
        if search {
            baseParams = [
               "latitude": latitude,
               "longitude": longitude,
                "term": keyWord
           ]
        }
        else {
            baseParams = [
               "latitude": latitude,
               "longitude": longitude,
           ]
        }
        
        for (key, value) in baseParams {
            let item = URLQueryItem(name: key, value: value)
            queryItems.append(item)
        }
        
        components.queryItems = queryItems
        return components.url!
    }
    
    static func getBusinessListForLocation(latitude: String, longitude: String, completion: @escaping ([Business]?) -> Void) {
        
        let url = getYelpUrl(latitude: latitude, longitude: longitude, search: false)
        var request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        
        // Insert API Key to request
        request.setValue("Bearer \(self.apiKey)", forHTTPHeaderField: "Authorization")
                
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task = session.dataTask(with: request) { (data, response, error) in
            // This will run when the network request returns
            if let error = error {
                print(error.localizedDescription)
            } else if let data = data {
                
                guard let safeResponse = try? JSONDecoder().decode(Result.self, from: data) else {
                    print("error decoding list of business")
                    return
                }
                
                let businessList = safeResponse.businesses
                return completion(businessList)

                }
            }
        
            task.resume()
    }
    
    static func getSearchResult(latitude: String, longitude: String, restaurantName: String, completion: @escaping ([Business]?) -> Void) {
        
        let url = getYelpUrl(latitude: latitude, longitude: longitude, keyWord: restaurantName, search: true)
        
        var request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        
        // Insert API Key to request
        request.setValue("Bearer \(self.apiKey)", forHTTPHeaderField: "Authorization")
                
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task = session.dataTask(with: request) { (data, response, error) in
            // This will run when the network request returns
            if let error = error {
                print(error.localizedDescription)
            } else if let data = data {
                
                guard let safeResponse = try? JSONDecoder().decode(Result.self, from: data) else {
                    print("error decoding search result")
                    return
                }
                
                let businessList = safeResponse.businesses
                return completion(businessList)

                }
            }
        
            task.resume()
    }
    
    static func getBusinessDetails(id: String, completion: @escaping (BusinessDetail?) -> Void) {
        
        var components = URLComponents(string: businessDetailbaseURL)!
        components.path += "/\(id)"

        let url = components.url!
        
        var request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        
        // Insert API Key to request
        request.setValue("Bearer \(self.apiKey)", forHTTPHeaderField: "Authorization")
                
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task = session.dataTask(with: request) { (data, response, error) in
            // This will run when the network request returns
            if let error = error {
                print(error.localizedDescription)
            } else if let data = data {
                guard let safeResponse = try? JSONDecoder().decode(BusinessDetail.self, from: data) else {
                    print("error decoding")
                    return
                }
                
                let businessDetail = safeResponse
                return completion(businessDetail)

                }
            }
        
            task.resume()
    }
    
    
    
}

extension Notification.Name {
    static let businessesLoadedFromYelp = Notification.Name(rawValue: "businessesLoadedFromYelp")
}
