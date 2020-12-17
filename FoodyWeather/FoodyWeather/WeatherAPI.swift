//
//  WeatherAPI.swift
//  FoodyWeather
//
//  Created by Abdullah Alseddiq on 12/17/20.
//

import Foundation

import Foundation

struct WeatherAPI {
        
    //Declaring params to prepare for call
    let baseURLString = "http://api.weatherapi.com/v1/current.json"
    private var apiKey = "96e182aa893140daa75163258201712"

    var latitude = ""
    var longitude = ""
    var location = ""
    
    /// The Yelp API init to get businesses for a supploed lat and long
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
    func getYelpUrl() -> URL {
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
    
    func getWeatherForLocation() {
        
        let url = getYelpUrl()
        var request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
                
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task = session.dataTask(with: request) { (data, response, error) in
            // This will run when the network request returns
            if let error = error {
                print(error.localizedDescription)
            } else if let data = data {
                print(String(data: data, encoding: .utf8))
                guard let safeResponse = try? JSONDecoder().decode(WeatherResult.self, from: data) else {
                    print("error decoding")
                    return
                }
                
                print(safeResponse.current)

                }
            }
        
            task.resume()
    }
}
