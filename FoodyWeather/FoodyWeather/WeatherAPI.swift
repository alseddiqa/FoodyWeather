//
//  WeatherAPI.swift
//  FoodyWeather
//
//  Created by Abdullah Alseddiq on 12/17/20.
//

import Foundation

import Foundation

struct WeatherAPI {
        
    let forcastBaseUrl = "http://api.weatherapi.com/v1/forecast.json"
    let baseURLString = "http://api.weatherapi.com/v1/current.json"
    private var apiKey = "96e182aa893140daa75163258201712"

    var latitude = ""
    var longitude = ""
    var location = ""
    
    /// The Weather API init to get weather information for a lat and long
    /// - Parameters:
    ///   - lat: latitude of the location to get businesses for
    ///   - lon: longitude of the location get businesses for
    init(lat:Double, lon: Double) {
        self.latitude = String(lat)
        self.longitude = String(lon)
        self.location = String(self.latitude + "," + self.longitude)
    }
    
    /// A function to set up the Yelp URL to get businesses
    /// - Returns: a URL after adding all of the params
    func getWeatherUrl() -> URL {
        var components = URLComponents(string: baseURLString)!
        var queryItems = [URLQueryItem]()
        
        let baseParams = [
            "q": location,
            "key": apiKey
        ]
        
        for (key, value) in baseParams {
            let item = URLQueryItem(name: key, value: value)
            queryItems.append(item)
        }
        
        components.queryItems = queryItems
        return components.url!
    }
    
    func getWeatherForLocation(completion: @escaping (WeatherResult?) -> Void){
        
        let url = getWeatherUrl()
        var request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
                
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task = session.dataTask(with: request) { (data, response, error) in
            // This will run when the network request returns
            if let error = error {
                print(error.localizedDescription)
            } else if let data = data {
                
                guard let safeResponse = try? JSONDecoder().decode(WeatherResult.self, from: data) else {
                    print("error decoding")
                    return
                }
        
                let weatherResult = safeResponse
                return completion(weatherResult)

                }
            }
        
            task.resume()
    }
    
    func getWeatherForcastUrl() -> URL {
        var components = URLComponents(string: baseURLString)!
        var queryItems = [URLQueryItem]()
        
        let baseParams = [
            "q": location,
            "key": apiKey,
            "days": "5"
        ]
        
        for (key, value) in baseParams {
            let item = URLQueryItem(name: key, value: value)
            queryItems.append(item)
        }
        
        components.queryItems = queryItems
        return components.url!
    }
    
    func getWeatherForLocation(completion: @escaping (WeatherForcast?) -> Void){
        
        let url = getWeatherForcastUrl()
        var request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
                
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task = session.dataTask(with: request) { (data, response, error) in
            // This will run when the network request returns
            if let error = error {
                print(error.localizedDescription)
            } else if let data = data {
                
                guard let safeResponse = try? JSONDecoder().decode(WeatherResult.self, from: data) else {
                    print("error decoding")
                    return
                }
        
                let weatherResult = safeResponse
                return completion(weatherResult)

                }
            }
        
            task.resume()
    }
}
