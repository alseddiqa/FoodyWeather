//
//  BusinessHoursViewController.swift
//  FoodyWeather
//
//  Created by Abdullah Alseddiq on 12/23/20.
//

import UIKit

class BusinessHoursViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource{

    //Declare outlets for the container view, collection view for the hours
    @IBOutlet var collectionView: UICollectionView!
    
    //Declare variables
    var business: Business!
    var businessDetail: BusinessDetail!
    var businessHours = [Open]()
    var businessStorage: BusinessStorage!

    override func viewWillAppear(_ animated: Bool) {
        collectionView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.dataSource = self
        collectionView.delegate = self
        if business != nil {
            getBusinessDetails(businessId: business.id)
        }
    }
    
    /// A helper function to get the business details
    /// - Parameter businessId: the business id to fetch the hours for
    func getBusinessDetails(businessId: String) {
        YelpAPI.getBusinessDetails(id: businessId) { (details) in
            guard let details = details else {
                return
            }
            self.businessDetail = details
            self.businessHours = self.businessDetail.hours[0].hourOpen
            self.collectionView.reloadData()
            self.storeBusinessHours()
        }
    }
    
    /// A helper function to store business hours if viewed business was searched
    func storeBusinessHours() {
        businessStorage.updateHoursForBusiness(businessId: business.id, hours: self.businessHours)
    }
    
    /// A helper function to transfer opening hours into pm or am
    /// - Parameter hour: hour of the day
    /// - Returns: Latin ante meridiem of the day
    func getTimeOfDay(hour: Int) -> String {
        if hour >= 0 && hour < 12 {
            return " am"
        }else {
            return  " pm"
        }
    }
    
    /// A helper function to get the day based on the index retrieved from yelp api
    /// - Parameter day: day index
    /// - Returns: returns the name of the day
    func getDayText(day: Int) -> String{
        switch day {
        case 0:
            return "Monday"
        case 1:
            return "Tuesday"
        case 2:
            return "Wednesday"
        case 3:
            return "Thursday"
        case 4:
            return "Friday"
        case 5:
            return "Saturday"
        default:
            return "Sunday"
        }
    }
    
    /// A helper function to reformat the open hours
    /// - Parameter start: first hour the business open
    /// - Returns: the open hour for the business
    func getHoursOpen(start: String) -> String{
        
        var resultTime = ""
        var startTimeOfDay = ""
        if let startHour = Int(start.prefix(2)) {
            startTimeOfDay = getTimeOfDay(hour: startHour)
            var startHourResult = startHour % 12
            if startHourResult == 0 {
                startHourResult = 12
            }
            resultTime += String(startHourResult) + ":" + start.suffix(2) + startTimeOfDay
        }
        
        return resultTime
       
    }
    
    /// A helper function to reformat the closing hours
    /// - Parameter start: last hour the business oerates
    /// - Returns: the closing hour for the business
    func getClosingHour(end: String) -> String {
        
        var resultTime = ""
        var endTimeOfDay = ""

        if let endHour = Int(end.prefix(2)){
            endTimeOfDay = getTimeOfDay(hour: endHour)
            var endHourResult = endHour % 12
            if endHourResult == 0 {
                endHourResult = 12
            }
            resultTime += String(endHourResult) + ":" + end.suffix(2) + endTimeOfDay
        }
        
        return resultTime
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return businessHours.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let identifier = "BusinessHourCell"
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! BusinessHourCell
        
        let day = businessHours[indexPath.item]
        cell.dayLabel.text = getDayText(day: day.day)
        cell.hoursOpenLabel.text = getHoursOpen(start: day.start)
        cell.closingHourLabel.text = getClosingHour(end: day.end)
        cell.shadowDecorate()
        return cell
    }
    
}
