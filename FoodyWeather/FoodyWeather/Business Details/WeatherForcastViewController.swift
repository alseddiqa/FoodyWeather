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
    var businessStorage: BusinessStorage!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        collectionView.dataSource = self
        collectionView.delegate = self
        if business != nil {
            getWeatherInformation()

        }
        
    }
    
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
            self.storeWeatherForcastResult()
        }
    }
    
    func storeWeatherForcastResult() {
        let b = SavedBusiness(name: business.name, businessId: business.id, reviewCount: business.reviewCount, businessLocation: business.location, category: business.categories[0].title, rating: business.rating, phone: business.displayPhone, imageURL: business.imageURL)
        let updated = b
        businessStorage.addBusiness(b)
        updated.forcastDays = self.forcastDays
        businessStorage.updateBusinessInformaton(oldBusiness: b, newBusiness: updated)
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
        
        let weather = forcastDays[indexPath.item]
        cell.weatherTempLabel.text = String(weather.day.avgtempC) + "°C"
        cell.weatherImage.load(url: URL(string: "http:" + weather.day.condition.icon)!)
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
