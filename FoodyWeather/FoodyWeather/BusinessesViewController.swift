//
//  BusinessesViewController.swift
//  FoodyWeather
//
//  Created by Abdullah Alseddiq on 12/16/20.
//

import UIKit

class BusinessesViewController: UIViewController {

    var businessesStore: BusinessStore!
    var yelpApi: YelpAPI!
    
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        businessesStore = BusinessStore()
        tableView.delegate = self
        tableView.dataSource = self
        
//        yelpApi = YelpAPI(lat: 37.7670169511878, lon: -122.42184275)
//        yelpApi.getBusinessListForLocation() { (restaurants) in
//            guard let restaurants = restaurants else {
//                return
//            }
//            self.businessesList = restaurants
//            self.tableView.reloadData()
//        }
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(observeStoreLoadNotification(note:)),
                                               name: .businessesLoadedYelp,
                                               object: nil)
        // Do any additional setup after loading the view.
        
    }
    
    @objc func observeStoreLoadNotification(note: Notification) {
        tableView.reloadData()
    }
    
    
}

extension BusinessesViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        businessesStore.businesses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BusinessCell") as! BusinessTableCell
        
        let business = businessesStore.businesses[indexPath.row]
        
        // Set name and phone of cell label
        cell.businessName.text = business.name
        cell.phoneNumber.text = business.displayPhone
        
        // Get reviews
        let reviews = business.reviewCount
        cell.reviews.text = String(reviews)
        
        // Get categories
        let categorie = business.categories[0].title
        cell.category.text = categorie
        
        // Set stars images
        let reviewDouble = business.rating
        cell.starsImage.image = Stars.dict[reviewDouble]!
        
        // Set Image of restaurant
        let imageUrlString = business.imageURL
        if let imageUrl = URL(string: imageUrlString) {
            cell.businessImage.load(url: imageUrl)
        }
    
        return cell

    }
    
}

extension UIImageView {
    func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}
