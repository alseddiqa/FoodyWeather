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
            self.getWeatherForNextDays()
        }
    }
    
    func getWeatherForNextDays() {
        var today = Date()
        let calendar = Calendar.current
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        for _ in 1...4 {
            let updateDay = calendar.date(byAdding: .day, value: 1, to: today)
            today = updateDay!
            let dateString = dateFormatter.string(from: updateDay!)
            requestWeatherInformationForDay(date: dateString)
        }
    }
    
    func  requestWeatherInformationForDay(date: String) {
        let api = WeatherAPI(lat: business.coordinates.latitude, lon: business.coordinates.longitude)
        api.getWeatherInformationForDay(date: date)
        { (weatherFocaseResult) in
            guard let weatherFocaseResult = weatherFocaseResult else {
                return
            }
            self.forcastDays += weatherFocaseResult.forecast.forecastday
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
        
        let weather = forcastDays[indexPath.item]
        cell.weatherTempLabel.text = String(weather.day.avgtempC) + "°C"
        cell.weatherImage.load(url: URL(string: "http:" + weather.day.condition.icon)!)
        
        switch indexPath.item{
        case 0:
            cell.dayLabel.text = "Today"
        case 1:
            cell.dayLabel.text = "Tomorrow"
        default:
            cell.dayLabel.text = getDateText(dateString: weather.date)
        }
        cell.shadowDecorate()
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        let foter = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "AnotherDay", for: indexPath) as UICollectionReusableView
        
//        anotherDay.layer.cornerRadius = 20.0
//        anotherDay.layer.masksToBounds = true
        
        return foter
    }
    
}


extension Date {
    var month: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM"
        return dateFormatter.string(from: self)
    }
    
}
