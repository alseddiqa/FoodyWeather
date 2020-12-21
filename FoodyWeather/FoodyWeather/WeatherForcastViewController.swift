//
//  WeatherForcastViewController.swift
//  FoodyWeather
//
//  Created by Abdullah Alseddiq on 12/21/20.
//

import UIKit

class WeatherForcastViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    @IBOutlet var collectionView: UICollectionView!
    
    var business: Business!
    var forcast: Forecast!
    var forcastDays = [Forecastday]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        collectionView.dataSource = self
        collectionView.delegate = self
        getWeatherInformation()
        
    }
    
    func getWeatherInformation() {
        
        let api = WeatherAPI(lat: business.coordinates.latitude, lon: business.coordinates.longitude)
        api.getWeatherForcastForBusiness()
        { (weatherFocaseResult) in
            guard let weatherFocaseResult = weatherFocaseResult else {
                return
            }
            self.forcast = weatherFocaseResult.forecast
            self.forcastDays = self.forcast.forecastday
            self.collectionView.reloadData()
        }
    }
    
    func getDateText(dateString: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"

        let calendar = Calendar.current
        
        let date = dateFormatter.date(from: dateString)!
        let day = calendar.component(.day, from: date)
        let month = String(date.month.prefix(3))
        return month + " " + String(day)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        forcastDays.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let identifier = "WeatherDayCell"
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! WeatherDayCell
        
        let weather = forcast.forecastday[indexPath.item]
        cell.weatherTempLabel.text = String(weather.day.avgtempC) + "°C"
        cell.weatherImage.load(url: URL(string: "http:" + weather.day.condition.icon)!)
        
        switch indexPath.item{
        case 0:
            cell.dayLabel.text = "Today"
        case 1:
            cell.dayLabel.text = "Tomorrow"
        case 2:
            cell.dayLabel.text = getDateText(dateString: weather.date)
        default:
            0
        }
        cell.shadowDecorate()
        return cell
    }
    
}


extension Date {
    var month: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM"
        return dateFormatter.string(from: self)
    }
    
}
