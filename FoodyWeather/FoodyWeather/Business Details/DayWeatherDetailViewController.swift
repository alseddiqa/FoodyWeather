//
//  DayWeatherDetailViewController.swift
//  FoodyWeather
//
//  Created by Abdullah Alseddiq on 12/22/20.
//

import UIKit

class DayWeatherDetailViewController: UIViewController {
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var datePicker: UIDatePicker!
    
    var forcastDay: Forecastday!
    var location = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        datePicker.backgroundColor = #colorLiteral(red: 0.1058823529, green: 0.1490196078, blue: 0.1725490196, alpha: 1)
        tableView.dataSource = self
        tableView.delegate = self
        setMinAndMaxDate()
        setPickerDate()
        if location.count == 0 {
            datePicker.isEnabled = false
        }
        
    }
    
    func setPickerDate() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let selectedDate = dateFormatter.date(from: forcastDay.date)
        if let selectedDate = selectedDate {
            self.datePicker.date = selectedDate
        }
    }
    
    func setMinAndMaxDate() {
        self.datePicker.minimumDate = Date()
        let calendar = Calendar.current
        let maxDate = calendar.date(byAdding: .day, value: 9, to: Date())
        self.datePicker.maximumDate = maxDate
    }
    
    func getHour(dateString: String) -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        
        let calendar = Calendar.current
        
        let date = dateFormatter.date(from: dateString)!
        let hour = calendar.component(.hour, from: date)
        
        var hourResult = hour % 12
        if hourResult == 0 {
            hourResult = 12
        }
        let time = String(hourResult)
        if hour >= 0 && hour < 12 {
            return time + " am"
        }else {
            return time + " pm"
        }
        
    }
    
    @IBAction func handleDateChange(_ sender: UIDatePicker) {
        let date = sender.date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dateString = dateFormatter.string(from: date)
        WeatherAPI.getWeatherInformationForDay(location: location, date: dateString) {
            (weatherFocaseResult) in
                guard let weatherFocaseResult = weatherFocaseResult else {
                    return
                }
            self.forcastDay = weatherFocaseResult.forecast.forecastday[0]
            self.tableView.reloadData()
        }
    }

}

extension DayWeatherDetailViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return forcastDay.hour.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "weatherCell") as! WeatherHourCell
        
        let hour = forcastDay.hour[indexPath.row]
        cell.timeLabel.text = getHour(dateString: hour.time)
        cell.tempLabel.text = String(hour.tempC) + "°C"
        cell.rainChanceLabel.text = hour.chanceOfRain + "%"
        cell.conditionIcon.load(url: URL(string: "http:" + hour.condition.icon)!)
        
        return cell
    }
    
    
}
