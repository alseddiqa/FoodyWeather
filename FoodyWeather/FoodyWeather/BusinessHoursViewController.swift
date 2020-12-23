//
//  BusinessHoursViewController.swift
//  FoodyWeather
//
//  Created by Abdullah Alseddiq on 12/23/20.
//

import UIKit

class BusinessHoursViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource{

    @IBOutlet var collectionView: UICollectionView!
    
    var business: Business!
    var businessDetail: BusinessDetail!
    var businessHours = [Hour]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.dataSource = self
        collectionView.delegate = self
        getBusinessDetails(businessId: business.id)
    }

    func getBusinessDetails(businessId: String) {
        let yelpApi = YelpAPI(lat: 0, lon: 0)
        yelpApi.getBusinessDetails(id: businessId) { (details) in
            guard let details = details else {
                return
            }
            self.businessDetail = details
            //do more update to UI
        }
    }
    
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
    
    func getHoursOpen(hours: String) {
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return businessHours.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let identifier = "BusinessHourCell"
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! BusinessHourCell
        
        let day = businessHours[indexPath.item]
        
        cell.dayLabel.text = getDayText(day: day.hourOpen[indexPath.row].day)
        cell.hoursOpenLabel.text = getHoursOpen()
        cell.shadowDecorate()
        return cell
    }
    
}
