//
//  WeatherForcastViewController.swift
//  FoodyWeather
//
//  Created by Abdullah Alseddiq on 12/21/20.
//

import UIKit

/// The VC class for the container view holding weather forcast for the current week
class WeatherForcastViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    //Declare outlets
    @IBOutlet var collectionView: UICollectionView!
    
    var business: Business!
    var forcast: Forecast!
    var forcastDays = [Forecastday]()
    var businessStorage: BusinessStorage!
    var lastFourDays = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.dataSource = self
        collectionView.delegate = self
        
        if business != nil {
            getWeatherInformation()
        }
    }
    
    /// A function to get the weather information for the current week
    func getWeatherInformation() {
        let location = String(business.coordinates.latitude) + "," + String(business.coordinates.longitude)
        WeatherAPI.getWeatherForcastForBusiness(location: location)
        { (weatherFocaseResult) in
            guard let weatherFocaseResult = weatherFocaseResult else {
                return
            }
            self.forcast = weatherFocaseResult.forecast
            self.forcastDays = self.forcast.forecastday
            self.collectionView.reloadData()
            self.getWeatherForNextDays()
        }
    }
    
    /// A helper function to store 3-days weather information if business was searched
    func storeWeatherForcastResult() {
        businessStorage.updateForcastForBusiness(businessId: business.id, forcast: self.forcastDays)
    }
    
    /// A helper function to request weather for more days. Weahter API free account  limits the result to 3 days. To get arround that, i request weather infomration for more days individually
    func getWeatherForNextDays() {
        let today = Date()
        let calendar = Calendar.current
        var updateDay = calendar.date(byAdding: .day, value: 2, to: today)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        for _ in 1...4 {
            updateDay = calendar.date(byAdding: .day, value: 1, to: updateDay!)
            let dateString = dateFormatter.string(from: updateDay!)
            requestWeatherInformationForDay(date: dateString)
        }
        self.storeWeatherForcastResult()
    }
    
    /// A function that makes the calls to weather APi to fetch weather information for a specific date
    /// - Parameter date: the date to request weather for
    func  requestWeatherInformationForDay(date: String) {
        let location = String(business.coordinates.latitude) + "," + String(business.coordinates.longitude)
        WeatherAPI.getWeatherInformationForDay(location: location , date: date)
        { (weatherFocaseResult) in
            guard let weatherFocaseResult = weatherFocaseResult else {
                return
            }
            self.forcastDays += weatherFocaseResult.forecast.forecastday
            self.collectionView.reloadData()
        }
        
    }
    
    /// A helper function to get the day of the week from the retrieved forcast
    /// - Parameters:
    ///   - index: index of the day
    ///   - dateString: the date to reformat
    /// - Returns: the description of the day
    func getDateText(index: Int , dateString: String) -> String {
        switch index{
        case 0:
           return "Today"
        case 1:
            return "Tomorrow"
        default:
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"

            let calendar = Calendar.current
            
            let date = dateFormatter.date(from: dateString)!
            let day = calendar.component(.day, from: date)
            let month = String(date.month.prefix(3))
            return month + " " + String(day)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        forcastDays.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let identifier = "WeatherDayCell"
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! WeatherDayCell
        
        self.forcastDays.sort()
        let weather = forcastDays[indexPath.item]
        cell.weatherTempLabel.text = String(weather.day.avgtempC) + "°C"
        cell.weatherImage.kf.setImage(with: URL(string: "http:" + weather.day.condition.icon)!)
        cell.dayLabel.text = getDateText(index: indexPath.item, dateString: weather.date)
        cell.shadowDecorate()
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "weatherDayDetail":
            if let selectedIndexPath =
                collectionView.indexPathsForSelectedItems?.first {
                let dayForcast = forcastDays[selectedIndexPath.row]
                let destinationVC = segue.destination as! DayWeatherDetailViewController
                destinationVC.forcastDay = dayForcast
                if business != nil{
                    destinationVC.location = String(business.coordinates.latitude) + "," + String(business.coordinates.longitude)
                }
            }
        default:
            preconditionFailure("Unexpected segue identifier.")
        }
    }
    
}


extension Date {
    var month: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM"
        return dateFormatter.string(from: self)
    }
    
}
