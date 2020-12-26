//
//  WeatherAPI.swift
//  FoodyWeather
//
//  Created by Abdullah Alseddiq on 12/17/20.
//

import Foundation

import Foundation

struct WeatherAPI {
        
    static let forcastBaseUrl = "http://api.weatherapi.com/v1/forecast.json"
    static let baseURLString = "http://api.weatherapi.com/v1/current.json"
    static let wetherAutoComplete = "http://api.weatherapi.com/v1/search.json"

    private static var apiKey = "96e182aa893140daa75163258201712"

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
    static func getWeatherUrl(location: String, search: Bool) -> URL {
        
        var components = URLComponents()
        if search == false {
            components = URLComponents(string: baseURLString)!
        } else {
            components = URLComponents(string: wetherAutoComplete)!
        }
        
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
    
    static func getWeatherForLocation(location: String, completion: @escaping (WeatherResult?) -> Void){
        
        let url = getWeatherUrl(location: location, search: false)
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
                
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
    
    static func getWeatherForcastUrl(location: String) -> URL {
        var components = URLComponents(string: forcastBaseUrl)!
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
    
    static func getWeatherForcastForBusiness(location: String, completion: @escaping (WeatherForecast?) -> Void){
        
        let url = getWeatherForcastUrl(location: location)
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
                
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task = session.dataTask(with: request) { (data, response, error) in
            // This will run when the network request returns
            if let error = error {
                print(error)
                
            } else if let data = data {

                do {
                    let safeResponse = try JSONDecoder().decode(WeatherForecast.self, from: data)
                    let weatherForcaseResult = safeResponse
                    return completion(weatherForcaseResult)
                }
                catch {
                    print(error)
                }
                
                }
            }
        
            task.resume()
    }
    
    static func getWeatherForcastUrlForDay(location: String, date: String) -> URL {
        var components = URLComponents(string: forcastBaseUrl)!
        var queryItems = [URLQueryItem]()
        
        let baseParams = [
            "q": location,
            "key": apiKey,
            "dt": date
        ]
        
        for (key, value) in baseParams {
            let item = URLQueryItem(name: key, value: value)
            queryItems.append(item)
        }
        
        components.queryItems = queryItems
        return components.url!
    }
    
    static func getWeatherInformationForDay(location: String, date: String, completion: @escaping (WeatherForecast?) -> Void) {
        
        let url =  getWeatherForcastUrlForDay(location: location, date: date)
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task = session.dataTask(with: request) { (data, response, error) in
            // This will run when the network request returns
            if let error = error {
                print(error.localizedDescription)
            } else if let data = data {
                //print(String(data: data, encoding: .utf8))
                guard let safeResponse = try? JSONDecoder().decode(WeatherForecast.self, from: data) else {
                    print("error decoding")
                    return
                }
        
                let weatherForcaseResult = safeResponse
                return completion(weatherForcaseResult)

                }
            }
        
            task.resume()
    }
    
    static func getSearchAutoComplete(keyWord: String, completion: @escaping ([SearchResult]?) -> Void) {
        
        let url = getWeatherUrl(location: keyWord, search: true)
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task = session.dataTask(with: request) { (data, response, error) in
            // This will run when the network request returns
            if let error = error {
                print(error.localizedDescription)
            } else if let data = data {
                guard let safeResponse = try? JSONDecoder().decode([SearchResult].self, from: data) else {
                    print("error decoding")
                    return
                }
        
                let weatherForcaseResult = safeResponse
                return completion(weatherForcaseResult)
                
                }
            }
        
            task.resume()
    }
}
