//
//  WeatherAPI.swift
//  FoodyWeather
//
//  Created by Abdullah Alseddiq on 12/17/20.
//

import Foundation

import Foundation

struct WeatherAPI {
    
    //Declaring End points
    static let forcastBaseUrl = "http://api.weatherapi.com/v1/forecast.json"
    static let baseURLString = "http://api.weatherapi.com/v1/current.json"
    static let wetherAutoComplete = "http://api.weatherapi.com/v1/search.json"

    //API key for the weatherAPI
    private static var apiKey = "96e182aa893140daa75163258201712"
    
    /// A function to set up the weather api URL to get auto complete results, or the current weather
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
    
    /// A function to fetch the current weather for a specified latitude and logititude
    /// - Parameters:
    ///   - location: location composed of latitude and logititude
    ///   - completion: returns the current weather for location
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
    
    /// A function to get a list of autocomple search result
    /// - Parameters:
    ///   - keyWord: the location key word to search
    ///   - completion: list of suggested location based
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
    
    /// A function that set the url to get the weather forcast for a day/ location
    /// - Parameters:
    ///   - location: location of the forcast to look up
    ///   - forDay: bool to search for day or not
    ///   - date: the date to look for the forcast
    /// - Returns: forcast for the day
    static func getWeatherForcastUrl(location: String, forDay: Bool, date: String = "") -> URL {
        var components = URLComponents(string: forcastBaseUrl)!
        
        var baseParams = [String:String]()
        if forDay == false {
             baseParams = [
                "q": location,
                "key": apiKey,
                "days": "5"
            ]
        }
        else {
             baseParams = [
                "q": location,
                "key": apiKey,
                "dt": date
            ]
        }
        
        var queryItems = [URLQueryItem]()
        
        for (key, value) in baseParams {
            let item = URLQueryItem(name: key, value: value)
            queryItems.append(item)
        }
        
        components.queryItems = queryItems
        return components.url!
    }
    
    /// A funtion that gets the forcast for business
    /// - Parameters:
    ///   - location: location of the business
    ///   - completion: the forcast for the specified business
    static func getWeatherForcastForBusiness(location: String, completion: @escaping (WeatherForecast?) -> Void){
        
        let url = getWeatherForcastUrl(location: location, forDay: false)
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
    
    /// A function that gets the weather information for day
    /// - Parameters:
    ///   - location: the location of the business
    ///   - date: the date to find the weather for
    ///   - completion: weather condition in that specific dat
    static func getWeatherInformationForDay(location: String, date: String, completion: @escaping (WeatherForecast?) -> Void) {
        
        let url =  getWeatherForcastUrl(location: location, forDay: true, date: date)
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task = session.dataTask(with: request) { (data, response, error) in
            // This will run when the network request returns
            if let error = error {
                print(error.localizedDescription)
            } else if let data = data {
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

}
