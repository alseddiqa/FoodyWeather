//
//  YelpAPI.swift
//  FoodyWeather
//
//  Created by Abdullah Alseddiq on 12/16/20.
//

import Foundation

struct YelpAPI {
    
    let businessDetailbaseURL = "https://api.yelp.com/v3/businesses"
    
    //Declaring params to prepare for call
    let baseURLString = "https://api.yelp.com/v3/businesses/search"
    private var apiKey = "OP-aAcjnPw7tYtofhaksNCxwZCVg6V2IOJ57UtSasvytaQxWAD3gSqrIY2kuz00Xc1vY9y6DhO3itWS_tP-JIWdV6mP4UNyfNOQMTqJRPyAzeTHMJ9GtZNL9qvrZX3Yx"

    var latitude = ""
    var longitude = ""
    
    /// The Yelp API init to get businesses for a supploed lat and long
    /// - Parameters:
    ///   - lat: latitude of the location to get businesses for
    ///   - lon: longitude of the location get businesses for
    init(lat:Double, lon: Double) {
        self.latitude = String(lat)
        self.longitude = String(lon)
    }
    
    /// A function to set up the Yelp URL to get businesses
    /// - Returns: a URL after adding all of the params
    func getYelpUrl() -> URL {
        var components = URLComponents(string: baseURLString)!
        var queryItems = [URLQueryItem]()
        
        let baseParams = [
            "latitude": latitude,
            "longitude": longitude,
        ]
        
        for (key, value) in baseParams {
            let item = URLQueryItem(name: key, value: value)
            queryItems.append(item)
        }
        
        components.queryItems = queryItems
        return components.url!
    }
    
    func getBusinessListForLocation(completion: @escaping ([Business]?) -> Void) {
        
        let url = getYelpUrl()
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
    
    func getSearchResult(restaurantName: String, completion: @escaping ([Business]?) -> Void) {
        
        var components = URLComponents(string: baseURLString)!
        var queryItems = [URLQueryItem]()
        
        let baseParams = [
            "latitude": latitude,
            "longitude": longitude,
            "term": restaurantName
        ]
        
        for (key, value) in baseParams {
            let item = URLQueryItem(name: key, value: value)
            queryItems.append(item)
        }
        
        components.queryItems = queryItems
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
    
    func getBusinessDetails(id: String, completion: @escaping (BusinessDetail?) -> Void) {
        
        var components = URLComponents(string: businessDetailbaseURL)!
        components.path += "/\(id)"
        print(components)

        let url = components.url!
        
        print(url)
        
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
