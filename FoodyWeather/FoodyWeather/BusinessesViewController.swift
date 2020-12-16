//
//  BusinessesViewController.swift
//  FoodyWeather
//
//  Created by Abdullah Alseddiq on 12/16/20.
//

import UIKit

class BusinessesViewController: UIViewController {

    var businessesList: [Business]!
    var yelpApi: YelpAPI!
    
    @IBOutlet var businessTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

}

extension BusinessesViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        businessesList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RestaurantCell") as! BusinessTableCell
        
        let business = businessesList[indexPath.row]
        
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
        let reviewDouble = 
            restaurant["rating"] as! Double
        cell.starsImage.image = Stars.dict[reviewDouble]!
        
        // Set Image of restaurant
        if let imageUrlString = restaurant["image_url"] as? String {
            let imageUrl = URL(string: imageUrlString)
            cell.restaurantImage.af.setImage(withURL: imageUrl!)
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
